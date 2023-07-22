export 'unsupported_database.dart'
    if (dart.library.js) 'web_database.dart'
    if (dart.library.ffi) 'mobile_desktop_database.dart';
