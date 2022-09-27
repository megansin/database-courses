import java.io.File;
import java.io.FileNotFoundException;
import java.util.Hashtable;
import java.util.Scanner;

public class HashIndex {

    private Hashtable<String, String> hashmap = new Hashtable<String, String>();

    /**
     * inserts the given key and value into hashmap
     * @param key key inserted: the RandomV value
     * @param value value inserted: the record locations
     */
    public void insert(String key, String value){
        //if key not in hash, insert
        if (!hashmap.containsKey(key)){
            hashmap.put(key, value);
        }

        //if it is, update the value
        updateValue(key,value);

    }

    /**
     * updates the value for a given key in the hashmap, adds the new location to the preexisting location
     * @param key key whose value is going to be updated
     * @param value new location being added to preexisting location value
     */
    public void updateValue(String key, String value){
        String updatedVal = hashmap.get(key) + value ;
        hashmap.put(key, updatedVal);
    }

    /**
     * reads file content and extracts the RandomV and the record's location
     * then it is inserted into the hash map
     * @param fileID file id for desired file to be read into frame
     * @throws FileNotFoundException
     */
    public void readFile(int fileID) throws FileNotFoundException {

        String theString = "";
        File file = new File("Project2Dataset/F" + fileID + ".txt");
        Scanner scanner = new Scanner(file);
        theString = scanner.nextLine();
        while (scanner.hasNextLine()) {
            theString = theString + "\n" + scanner.nextLine();
        }

        char[] charArray = theString.toCharArray();

        for (int i = 0; i < charArray.length-40; i=i+40) {
            String randomVal = "";
            randomVal = randomVal + charArray[i+33] + charArray[i+34] + charArray[i+35] + charArray[i+36];

            //location is essentially a 4 digit number string with a period separating locations
            //file number (2 digits) + offset (2 digits) + "."
            String location = "";

            if (i<10){
                location = location + charArray[i+1] + charArray[i+2] + "0" + i + ".";
            }

            location = location + charArray[i+1] + charArray[i+2] + i + ".";

            insert(randomVal, location);
        }
    }

    /**
     * finds locations of inputted v using hashmap and prints all the records
     * @param v random value searching for
     * @throws FileNotFoundException
     */
    public void search(String v) throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        String locationsString = hashmap.get(v);
        String[] locationsArray = locationsString.split("\\.");
        String records = "";
        int numOfFile = 0;

        for (String loc : locationsArray) {

            String fileNum = loc.substring(0, 2);
            int offset = Integer.valueOf(loc.substring(2));

            String theString = "";
            File file = new File("Project2Dataset/F" + fileNum + ".txt");
            numOfFile++;
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();
            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }

            char[] charArray = theString.toCharArray();

            for (int i = offset; i < 40; i++) {
                records = records + charArray[i];
            }
            records = records + "\n";
        }

        System.out.println("Records: " + records);
        System.out.println("Hash-based index used");
        System.out.println("Time taken to answer query: " + sw.elapsedTime() + " ms");
        System.out.println("Data files read: " + numOfFile);

    }


}
