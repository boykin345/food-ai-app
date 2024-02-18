import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  // 图片文件路径
  final imagePath = 'assets/A1.png';
  // 输出Base64编码的文件路径
  final outputFilePath = 'assets/base64.txt';

  // 读取图片文件为字节数据
  final imageBytes = await File(imagePath).readAsBytes();
  // 将字节数据转换为Base64字符串
  final base64String = base64Encode(imageBytes);

  // 将Base64字符串写入文件
  await File(outputFilePath).writeAsString(base64String);

  print('Base64编码已保存到文件：$outputFilePath');
}