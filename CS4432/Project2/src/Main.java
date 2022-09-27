import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {
    static boolean hashCreated = false;
    static boolean arrayCreated = false;
    static HashIndex hi = new HashIndex();
    static ArrayIndex ai = new ArrayIndex();

    public static void main(String[] args) throws FileNotFoundException {
        System.out.println("Program is ready and waiting for user command.");
        Main.run();
    }

    /**
     * creates the hash-based and array-based indexes
     * @param hi hash index object to be initiated
     * @param ai array index object to be initiated
     * @throws FileNotFoundException
     */
    public static void createIndexes(HashIndex hi, ArrayIndex ai) throws FileNotFoundException {
        //build hash and array index structure
        for (int i = 1; i < 100; i++) {
            hi.readFile(i);
            ai.readFile(i);
            hashCreated = true;
            arrayCreated = true;
        }
        System.out.println("The hash-based and array-based indexes are built successfully. Program is ready and waiting for user command.");
    }

    /**
     * Looks for locations of v, prints out all records where v is located
     * If there are no indexes built, then you should perform a full table scan.
     * If there are indexes, then for equality search use the hash-based index.
     * @param v inputted random value we are searching for
     * @throws FileNotFoundException
     */
    public static void fullTableScanEquality(String v) throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        String records = "";

        for (int filenum = 1; filenum < 100; filenum++) {
            //go through each file
            String theString = "";
            File file = new File("Project2Dataset/F" + filenum + ".txt");
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();
            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }

            char[] charArray = theString.toCharArray();

            //go through each 33-37, if match then add to mega string i through i+40
            for (int i = 0; i < charArray.length-40; i=i+40) {
                String randomVal = "";
                randomVal = randomVal + charArray[i+33] + charArray[i+34] + charArray[i+35] + charArray[i+36];

                if (randomVal.equals(v)){
                    for (int j = 0; j < 40; j++) {
                        records = records + charArray[i+j];
                    }
                }
                records = records + "\n";
            }

        }
        //always go through all the data files --> 99
        System.out.println("Records: " + records);
        System.out.println("Table Scan used");
        System.out.println("Time taken to answer query: " + sw.elapsedTime() + " ms");
        System.out.println("Data files read: 99");
    }

    /**
     * Looks for records that have a random value within the bounds
     * If there are no indexes built, then you should perform a full table scan.
     * If there are indexes, then for range search use the array-based index.
     * @param v1 lower bounds in search
     * @param v2 upper bounds in search
     * @throws FileNotFoundException
     */
    public static void fullTableScanRange(String v1, String v2) throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        String records = "";

        int v1Int = Integer.parseInt(v1);
        int v2Int = Integer.parseInt(v2);

        for (int filenum = 1; filenum < 100; filenum++) {
            //go through each file
            String theString = "";
            File file = new File("Project2Dataset/F" + filenum + ".txt");
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();
            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }

            char[] charArray = theString.toCharArray();

            //go through each 33-37, if match then add to mega string i through i+40
            for (int i = 0; i < charArray.length-40; i=i+40) {
                String randomVal = "";
                randomVal = randomVal + charArray[i+33] + charArray[i+34] + charArray[i+35] + charArray[i+36];

                int randomVInt = Integer.parseInt(randomVal);
                if (randomVInt > v1Int && randomVInt < v2Int) {
                    for (int j = 0; j < 40; j++) {
                        records = records + charArray[i+j];
                    }
                }
                records = records + "\n";
            }

        }
        //always go through all the data files --> 99
        System.out.println("Records: " + records);
        System.out.println("Table Scan used");
        System.out.println("Time taken to answer query: " + sw.elapsedTime() + " ms");
        System.out.println("Data files read: 99");
    }

    /**
     * prints all the records that do not have the inputted random value v
     * @param v random value we are NOT searching for
     * @throws FileNotFoundException
     */
    public static void fullTableScanInequality(String v) throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        String records = "";

        for (int filenum = 1; filenum < 100; filenum++) {
            //go through each file
            String theString = "";
            File file = new File("Project2Dataset/F" + filenum + ".txt");
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();
            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }

            char[] charArray = theString.toCharArray();

            //go through each 33-37, if match then add to mega string i through i+40
            for (int i = 0; i < charArray.length-40; i=i+40) {
                String randomVal = "";
                randomVal = randomVal + charArray[i+33] + charArray[i+34] + charArray[i+35] + charArray[i+36];

                if (!randomVal.equals(v)){
                    for (int j = 0; j < 40; j++) {
                        records = records + charArray[i+j];
                    }
                }
                records = records + "\n";
            }

        }
        //always go through all the data files --> 99
        System.out.println("Records: " + records);
        System.out.println("Time taken to answer query: " + sw.elapsedTime() + " ms");
        System.out.println("Data files read: 99");
    }

    /**
     * loops and runs the program/commands
     * @throws FileNotFoundException
     */
    public static void run() throws FileNotFoundException {
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine();

        if (s.equals("CREATE INDEX ON Project2Dataset (RandomV)")) {
            Main.createIndexes(hi, ai);
        }

        else if (s.contains("SELECT * FROM Project2Dataset WHERE RandomV = ")){
            String v = s.substring(s.length() - 1);

            if (hashCreated){
                hi.search(v);
            }

            else {
                fullTableScanEquality(v);
            }

        }

        else if (s.contains("SELECT * FROM Project2Dataset WHERE RandomV > ") && s.contains("AND RandomV < ")){
            int indexGreaterThan = s.indexOf(">") + 2;
            int indexAND = s.indexOf("AND") - 1;
            int indexLessThan = s.indexOf("<") + 2;

            String v1 = s.substring(indexGreaterThan, indexAND);
            String v2 = s.substring(indexLessThan);

            if (arrayCreated){
                ai.search(v1, v2);
            }

            else{
                fullTableScanRange(v1, v2);
            }

        }

        else if (s.contains("SELECT * FROM Project2Dataset WHERE RandomV != ")){
            String v = s.substring(s.length() - 1);
            fullTableScanInequality(v);
        }

        else {
            Main.run();
        }

        Main.run();
    }

}
