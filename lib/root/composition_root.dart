import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/cache/local_cache.dart';
import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/data/datasource/sqflite_datasource.dart';
import 'package:messenger_app/data/factories/db_factory.dart';
import 'package:messenger_app/data/services/image_upload.dart';
import 'package:messenger_app/root/routes/home_route.dart';
import 'package:messenger_app/state_management/message/message_bloc.dart';
import 'package:messenger_app/state_management/receipt/receipt_bloc.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:messenger_app/view/screens/home/home.dart';
import 'package:messenger_app/view/screens/home/state_management/home_cubit.dart';
import 'package:messenger_app/root/routes/onboarding_router.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/state_management/chats_cubit.dart';
import 'package:messenger_app/view/screens/message_thread/messge_thread.dart';
import 'package:messenger_app/view/screens/message_thread/state_management/message_thread_cubit.dart';
import 'package:messenger_app/view/screens/onboarding/onboarding.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/onboarding/onboarding_cubit.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/profile_image/profile_image_cubit.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:messenger_app/viewmodels/chat_view_model.dart';
import 'package:messenger_app/viewmodels/chats_view_model.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:service/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  // service
  static late RethinkDb _r;
  static late Connection _connection;
  static late IUserService _userService;
  static late Database _db;
  static late IMessageService _messageService;
  static late IDatasource _datasource;
  static late ILocalCache _localCache;
  static late MessageBloc _messageBloc;
  static late ITypingNotification _typingNotification;
  static late TypingNotificationBloc _typingNotificationBloc;
  static late ChatsCubit _chatsCubit;

  static final String _host = WidgetUltil.getHost('rethink');
  static final int _port = WidgetUltil.getPort('rethink');

  static Widget start() {
    final user = _localCache.fetch('USER');
    return user.isEmpty
        ? composeOnBoardingUI()
        : composeHomeUI(User.fromJson({...user, "last_seen": DateTime.now()}));
  }

  //intial
  static configure() async {
    // service
    _r = RethinkDb();
    _connection = await _r.connect(host: _host, port: _port);
    _userService = UserService(_r, _connection);
    _messageService = MessageService(_r, _connection);
    _typingNotification = TypingNotification(_connection, _r, _userService);

    // local
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqfliteDatasource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);

    // bloc
    _messageBloc = MessageBloc(_messageService);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification);
    final ChatsViewModel _viewModel = ChatsViewModel(_datasource, _userService);
    _chatsCubit = ChatsCubit(_viewModel);
    // _db.delete('chats');
    // _db.delete('messages');
  }

  // bloc home
  static Widget composeHomeUI(User me) {
    final HomeCubit homeCubit = HomeCubit(_userService, _localCache);
    final IHomeRouter router =
        HomeRouter(showMessageThread: composeMessageThreadUI);

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) => homeCubit),
      BlocProvider(create: (BuildContext context) => _messageBloc),
      BlocProvider(create: (BuildContext context) => _typingNotificationBloc),
      BlocProvider(create: (BuildContext context) => _chatsCubit),
    ], child: Home(me: me, router: router));
  }

  // bloc boarding
  static Widget composeOnBoardingUI() {
    final String _host = WidgetUltil.getHost('image');
    final ImageUploader imageUploader = ImageUploader('$_host/upload');
    final OnboardingCubbit obCubbit =
        OnboardingCubbit(_userService, imageUploader, _localCache);
    final ProfileImageCubit piCubit = ProfileImageCubit();
    final IOnboardingRouter router = OnboardingRouter(composeHomeUI);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => obCubbit),
        BlocProvider(create: (BuildContext context) => piCubit),
      ],
      child: Onboarding(router: router),
    );
  }

  // bloc boarding
  static Widget composeMessageThreadUI(User receiver, User me,
      {required String chatId}) {
    final ChatViewModel viewModel = ChatViewModel(_datasource);
    final MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    final IReceiptService receiptService = ReceiptService(_r, _connection);
    final ReceiptBloc receiptBloc = ReceiptBloc(receiptService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => messageThreadCubit),
        BlocProvider(create: (BuildContext context) => receiptBloc),
      ],
      child: MessageThread(
        chatId: chatId,
        receiver: receiver,
        me: me,
        chatsCubit: _chatsCubit,
        messageBloc: _messageBloc,
        typingNotificationBloc: _typingNotificationBloc,
      ),
    );
  }
}
