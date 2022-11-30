# 창의공학 양방향 iot 과제


<img src="https://user-images.githubusercontent.com/61526925/204763893-f2a8641a-3b45-47da-be86-6a52e59cba0c.gif">

# 아두이노 코드 설명
void setup(){  
  Serial.begin(9600); // 시리얼을 시작합니다  
  pinMode(13, OUTPUT); // 13번에 led를 꽂고 사용합니다.  
}


double th(int v) { // 온도계의 값을 섭씨로 변환해주는 함수입니다.
  double t;
  t = log(((10240000/v) - 10000));
  t = 1 /(0.001129148 + (0.000234125*t) + (0.0000000876741*t*t*t));
  t = t - 273.15; // 화씨를 섭씨로 바꾸어줍니다.
  return t;
}
void loop(){
  int a=analogRead(A0); // 시미스터 온도계로 온도를 측정합니다.
  Serial.println(th(a)); // 시리얼을 이용해 변환된 온도값을 서버(프로세싱)에 보내줍니다.
  int dly = (Serial.readString()).toInt(); // 클라이언트(앱인벤터)에서 보낸 값을 서버(프로세싱)에서 시리얼로 보낸것을 받습니다.
  digitalWrite(13, HIGH); // led를 켭니다.
  delay(dly); // 시리얼로 받은 값만큼 쉽니다.
  digitalWrite(13, LOW); // led를 끕니다.
  delay(dly); // 시리얼로 받은 값만큼 쉽니다.
}

# 앱인벤터 코드 설명
import processing.serial.*; // 시리얼을 사용하겠다는 코드입니다
import processing.net.*;

Serial p; // 시리얼로 아두이노와 연결합니다.
Server s; // 서버로 클라이언트(앱인벤터)와 연결합니다.
Client c; // 앱인벤터 입니다.
void setup() {
  s = new Server(this, 1234); // 포트 1234로 서버를 만듭니다.
  p = new Serial(this, "COM5", 9600); // 포트번호 5번에 있는 아두이노와 연결합니다.
}
String msg;
void draw() {
  c = s.available(); 
  if (c!=null) { //클라이언트가 있을떄
    String m = c.readString(); // 클라이언트에서 보낸 문자열을 받습니다.
    if (m.indexOf("PUT")==0) { // 깜빡이는 주기입니다
      int n = m.indexOf("\r\n\r\n")+4;
      m = m.substring(n);
      m += '\n';
      print(m); // 서버(프로세싱)화면에 출력합니다
      p.write(m); // 아두이노에 시리얼로 값을 보내줍니다.
    }
    else if (m.indexOf("GET")==0) { // 온도값입니다
      c.write("HTTP/1.1 200 OK\r\n"); // POST 규격
      c.write("Content-length: " + msg.length() + " \r\n\r\n"); // 데이터 길이
      c.write(msg); // 클라이언트(앱인벤터)에 값을 줍니다.
    }
  }
  if (p.available()>0) { // 시리얼이 통신이 될떄
    String m = p.readStringUntil('\n'); // 엔터가 나올때까지 읽습니다
    if (m!=null) {
      msg = m; 
      print(m);
    }
  }
}

# 앱인벤터 설명

