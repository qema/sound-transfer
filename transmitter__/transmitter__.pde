import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave wave;
String msg = "Hello World!";
String bits = "";
char lastBit = 0;
int curBit = 0;

PFont font;

void setup ()
{
  size (300,300);
  background(0);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  wave = new SineWave(0,0.5,out.sampleRate());
  out.addSignal (wave);
  
  font = createFont ("monospaced",16);
  textFont (font);
  textAlign (LEFT,TOP);
  
  text ("Sending message...",0,0);
  
  bits = convertMsg (msg);
  
  frameRate (8);
}

void draw ()
{
  if (curBit < bits.length()) {
    sendBit (bits.charAt(curBit));
    curBit++;
  } else {
    sendBit ((char)0);
    text ("Message sent.",0,20);
  }
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

void sendBit (char d)
{
  if (d == '*') wave.setFreq (988);
  if (d == '0') wave.setFreq (1174);
  if (d == '1') wave.setFreq (784);
  if (d == '!') wave.setFreq (1976);
  if (d == '.') wave.setFreq (1568);
  if (d == 0) wave.setFreq (0);
}

String convertMsg (String m)
{
  String o="",n="!";
  char c=0;
  for (int i=0;i<m.length();i++) {
    o = o.concat(binary(m.charAt(i)).substring(8,16));
  }
  //println (o);
  for (int i=0;i<o.length();i++) {
    n += c;
    if (o.charAt(i) == c) {
      n = n.concat("*");
    }
    c = o.charAt(i);
  }
  n += c;
  n = n.concat(".");
  //println (n);
  //println (translateSignal (n));
  return n;
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
