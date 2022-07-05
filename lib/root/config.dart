/// android-real
/// android-emulator
/// ios
/// web
const String device = 'android-real';

const Map<String, Map<String, dynamic>> hosts = {
  'local-rethink': {
    'host-android-real': '192.168.27.22',
    'host-android-emulator': '10.0.2.2',
    'host-ios': '127.0.0.1',
    'host-web': '127.0.0.1',
    'port': 49154,
  },
  'local-image': {
    'host-$device': 'https://imageservice.loca.lt',
    'port': 3000,
  }
};
