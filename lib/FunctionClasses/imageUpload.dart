import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

MediaType getMediaTypeFromFilePath(String filePath) {
  final ext = path.extension(filePath).toLowerCase();
  switch (ext) {
    case '.jpg':
    case '.jpeg':
      return MediaType('image', 'jpeg');
    case '.png':
      return MediaType('image', 'png');
    case '.gif':
      return MediaType('image', 'gif');
    default:
      return MediaType('application', 'octet-stream'); // generic binary
  }
}

Future uploadImagesToBackend(List<XFile> images,postId,mainUrl)async{

  try{
  final uri = Uri.parse("${mainUrl.trim()}/imageUpload");
  var request = http.MultipartRequest('POST',uri);
  
  for (XFile img in images){
    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        img.path,
        contentType: getMediaTypeFromFilePath(img.path)
      )
    );
  }

  request.fields['postId'] = postId;
  
  var response = await request.send();
  if(response.statusCode == 200){
    print("✅ Upload Success");
    final body = await response.stream.bytesToString();
    return body;
  }else{
   return "❌ Upload failed: ${response.statusCode}";
  }}
      catch(e){
    print("Upload Error: $e");
      }
  
}

