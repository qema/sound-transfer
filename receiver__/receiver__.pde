import krister.Ess.*;

int bufferSize=256;
AudioInput in;
String signal=" ",data=" ";
boolean procData;

PFont font;

void setup ()
{
  size (512,300);
  Ess.start (this);
  in = new AudioInput (bufferSize);
  in.start();
  
  font = createFont ("monospaced",16);
  textFont (font);
  textAlign (LEFT,TOP);
  frameRate (16);
}

void draw ()
{
  background (0);
  stroke (255);
  for (int i=0;i<bufferSize-1;i++) {
    line (i*2,200+in.buffer[i]*100,i*2+1,200+in.buffer[i+1]*100);
  }
  float[] xin = new float[bufferSize];
  for (int i=0;i<bufferSize;i++) {
    xin[i] = in.buffer[i];
  }
  if (fourier(xin,988*bufferSize/in.sampleRate,bufferSize)>0.05) {
    procData ('*');
  }else if (fourier(xin,1174*bufferSize/in.sampleRate,bufferSize)>0.05) {
    procData ('0');
  }else if (fourier(xin,784*bufferSize/in.sampleRate,bufferSize)>0.05) {
    procData ('1');
  }else if (fourier(xin,1976*bufferSize/in.sampleRate,bufferSize)>0.05) {
    procData ('!');
  }else if (fourier(xin,1568*bufferSize/in.sampleRate,bufferSize)>0.05) {
    procData ('.');
  }
  data = translateSignal(signal);
  text (data,0,30);
  text (signal,0,0);
}

double fourier(float x_in[],float n,int len)
{
  float[] x_complex = {0,0};
  for (int i=0;i<len;i++) {
    x_complex[0] += x_in[i] * cos(PI*2*i*n/ (float)len);
    x_complex[1] += x_in[i] * sin(PI*2*i*n/ (float)len);
  }
  return sqrt(x_complex[0]*x_complex[0] + x_complex[1]*x_complex[1]) / (double) len;
}

void procData (char d)
{
  if (d == '!') {
    procData = true;
    signal = " ";
    data = " ";
  } else if (d == '.') {
    procData = false;
    data = translateSignal(signal);
  } else if (signal.charAt(signal.length()-1) != d) {
    signal += d;
  }
}

String translateSignal (String s)
{
  String filtered="",byteDat="",res="";
  char tmp;
  for (int i=0;i<s.length();i++) {
    if (s.charAt(i) == '1') filtered += "1";
    if (s.charAt(i) == '0') filtered += "0";
  }
  //filtered += " ";
  for (int i=0;i<filtered.length();i++) {
    byteDat += filtered.charAt(i);
    if (byteDat.length() == 8) {
      tmp = (char)unbinary(byteDat);
      res += tmp;
      byteDat = "";
    }
  }
  return res;
}
