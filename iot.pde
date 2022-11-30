import processing.serial.*;
import processing.net.*;

Serial p;
Server s;
Client c;
void setup() {
  s = new Server(this, 1234);
  p = new Serial(this, "COM5", 9600);
}
String msg;
void draw() {
  c = s.available();
  if (c!=null) {
    String m = c.readString();
    if (m.indexOf("PUT")==0) {
      int n = m.indexOf("\r\n\r\n")+4;
      m = m.substring(n);
      m += '\n';
      print(m);
      p.write(m);
    }
    else if (m.indexOf("GET")==0) {
      c.write("HTTP/1.1 200 OK\r\n"); // POST 규격
      c.write("Content-length: " + msg.length() + " \r\n\r\n"); // 데이터 길이
      c.write(msg);
    }
  }
  if (p.available()>0) {
    String m = p.readStringUntil('\n');
    if (m!=null) {
      msg = m;
      print(m);
    }
  }
}
