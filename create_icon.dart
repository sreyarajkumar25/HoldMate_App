import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

void main() {
  // Create a 512x512 image
  final image = img.Image(width: 512, height: 512);
  
  // Fill with gradient color (purple)
  img.fillRect(image, 0, 0, 512, 512, color: img.ColorRgb8(108, 99, 255));
  
  // Add text "HM" in center
  img.drawString(image, 'HM', 
    font: img.arial, 
    x: 200, 
    y: 250, 
    color: img.ColorRgb8(255, 255, 255),
    fontSize: 120,
  );
  
  // Save the image
  final bytes = img.encodePng(image);
  File('assets/icons/app_icon.png').writeAsBytesSync(bytes);
  print('✅ Icon created at assets/icons/app_icon.png');
}
