import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  // google sheets api key
  @EnviedField(varName: 'GOOGLE_SHEETS_API_KEY', obfuscate: true)
  static final String googleSheetsApiKey = _Env.googleSheetsApiKey;
}
