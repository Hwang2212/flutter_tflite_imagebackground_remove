import 'package:flython/flython.dart';

class Python extends Flython {
  static const cmdRemoveBg = 1;
  // static const cmdOcrClipboard = 20;

  Future<dynamic> removeBg(String path) async {
    var command = {
      "cmd": cmdRemoveBg,
      "path": path,
    };
    await runCommand(command);
  }

  // Future<String?> ocrClipboard() async {
  //   var command = {"cmd": cmdRemoveBg};
  //   final result = await runCommand(command);
  //   if (result["success"]) {
  //     return result["result"];
  //   } else {
  //     return null;
  //   }
  // }
}
