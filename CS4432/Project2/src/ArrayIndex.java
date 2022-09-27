import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.Scanner;

public class ArrayIndex {

    private String[] array = new String[5000];

    public ArrayIndex(){
        for (int i = 0; i<array.length; i++)
            array[i] = "";
    }

    /**
     * reads file content and extracts the RandomV and the record's location
     * then it is inserted into the array
     * @param fileID file id for desired file to be read into frame
     * @throws FileNotFoundException
     */
    public void readFile(int fileID) throws FileNotFoundException {

        String theString = "";
        File file = new File("Project2Dataset/F" + fileID + ".txt");
        Scanner scanner = new Scanner(file);
        theString = scanner.nextLine();
        while (scanner.hasNextLine()) {
            theString += "\n" + scanner.nextLine();
        }

        char[] charArray = theString.toCharArray();

        for (int i = 0; i < charArray.length-40; i=i+40) {
            String randomVal = "";
            randomVal = randomVal + charArray[i+33] + charArray[i+34] + charArray[i+35] + charArray[i+36];
            //location is essentially a 4 digit number string with a period separating locations
            //file number (2 digits) + offset (2 digits) + "."
            String location = "";

            location = location + charArray[i+1] + charArray[i+2] + i + ".";

            int key = Integer.parseInt(randomVal)-1;
            array[key] = array[key] + location;

        }
        for(String i:array)
            System.out.println(i);
    }

    /**
     * searches through array and prints all the records that are within inputted bounds
     * @param v1 lower bounds of query lookup
     * @param v2 upper bounds of query lookup
     * @throws FileNotFoundException
     */
    public void search(String v1, String v2) throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        int v1Int = Integer.parseInt(v1);
        int v2Int = Integer.parseInt(v2);
        String records = "";
        int numOfFile = 0;

        for (int i = v1Int-1; i < v2Int-1; i++) {
            String locationsString = array[i];
            String[] locationsArray = locationsString.split("\\.");

            for (String loc : locationsArray) {
//                System.out.println(loc);
                if(loc.equals(""))
                    continue;
//                System.out.println(loc);
                String fileNum = loc.substring(0, 2);
                String offset = loc.substring(2);
//                System.out.println(offset);
                int offsetInt = Integer.parseInt(offset);
                String theString = "";
                if(fileNum.startsWith("0"))
                    fileNum = fileNum.substring(1);

                File file = new File("Project2Dataset/F" + fileNum + ".txt");
                numOfFile++;
                Scanner scanner = new Scanner(file);
                theString = scanner.nextLine();
                while (scanner.hasNextLine()) {
                    theString = theString + "\n" + scanner.nextLine();
                }

                char[] charArray = theString.toCharArray();

                for (int j = offsetInt; j < 40; j++) {
                    records = records + charArray[j];
                }
                records = records + "\n";

            }

        }
        System.out.println("Records: " + records);
        System.out.println("Array-based index used");
        System.out.println("Time taken to answer query: " + sw.elapsedTime() + " ms");
        System.out.println("Data files read: " + numOfFile);
    }

}
