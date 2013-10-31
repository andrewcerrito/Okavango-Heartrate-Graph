// First day of expedition - Sep 07 or 08. Tenth day Sep 17 or 18
import java.util.Date;
import java.text.SimpleDateFormat;

PFont font;
ArrayList <Entries> entryList = new ArrayList();
float maxHeartrate = 0;
Entries maxHeartRateEntry;

void setup() {
  size(1280, 720, P3D);
  background(0);
  font = createFont("Minion Pro Regular", 24);
  loadJSONData("http://intotheokavango.org/api/timeline?date=20130917&types=ambit");
  maxHeartRateEntry = new Entries();
  getMaxHeartrate();
  println(entryList.size());
}

void draw() {
  background(0);
  drawJSONData();
  drawGraphLine();
  drawMouseLine();
}

void loadJSONData(String APIaddress) {
  // "DateTime": "2013-09-17T10:43:25+0200",
  // PM in military time: "2013-09-17T17:29:45+0200"

  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
  JSONObject myJSON = loadJSONObject(APIaddress);
  JSONArray features = myJSON.getJSONArray("features");

  for (int i = 0; i < features.size(); i++) {
    Entries entry = new Entries();
    JSONObject singleFeature = features.getJSONObject(i);
    JSONObject properties = singleFeature.getJSONObject("properties");
    String person = properties.getString("Person");
    float heartrate = properties.getFloat("HR", -1); // return -1 if there is no heartrate entry
    String datetime = properties.getString("DateTime");
    datetime = datetime.substring(0, 19); // trim junk off the end of the string
    if (person.equals("John") && heartrate != -1 && datetime != null) { // filter out irrelevant entries
      entry.person = properties.getString("Person");
      entry.heartrate = properties.getFloat("HR");
      entry.datetime = properties.getString("DateTime");
      try {
        entry.date = sdf.parse(entry.datetime);
        // println(entry.date);
      } 
      catch (Exception e) {
        println("Error parsing date: " + e);
      }
      entry.pos = new PVector(0, 0);
      entryList.add(entry);
      // println("added");
    }
  }
}


void getMaxHeartrate() {
  for (Entries en:entryList) {
    if (en.heartrate > maxHeartrate) {
      maxHeartrate = en.heartrate;
      maxHeartRateEntry = en;
    }
  }
}


void drawJSONData() {
  for (int i = 0; i < entryList.size() - 1; i++) {
    Entries en = entryList.get(i);
    en.tpos.x = (int) map(i, 0, entryList.size(), 5, width-5);
    en.tpos.y = (int) map(en.heartrate, 1, maxHeartrate, height-10, 10);
    stroke(255);
    en.update();
    en.render();
  }
}

void drawGraphLine() {
  noFill();
  stroke(255);
  beginShape();
  for (int i = 0; i < entryList.size() -1; i++) {
    Entries en = entryList.get(i);
    vertex(en.pos.x, en.pos.y);
  }
  endShape();
}

void drawMouseLine() {
  for (int i = 0; i < entryList.size() - 1; i++) {
    Entries en = entryList.get(i);
    pushStyle();
    if (mouseX == (int) en.pos.x) {
      // if (abs (mouseX - en.pos.x) < 0.1) {
      stroke(255, 0, 0);
      line(en.pos.x, 0, en.pos.x, en.pos.y);
      popStyle();
      textFont(font);
      textAlign(CENTER);
      text("Date and time: " + en.date + "  Heartrate: " + en.heartrate, width/2, height - 100);
      text("Largest Heartrate of Day: " + maxHeartRateEntry.date + "  Heartrate: " + maxHeartRateEntry.heartrate, width/2, height - 50);
    }
  }
}

