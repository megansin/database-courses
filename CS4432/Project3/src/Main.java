import java.io.File;
import java.io.FileNotFoundException;
import java.util.Hashtable;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws FileNotFoundException {
        Main.run();
    }

    /**
     * loops and runs the program/commands
     *
     * @throws FileNotFoundException
     */
    public static void run() throws FileNotFoundException {
        System.out.println("Program is ready and waiting for user command.");
        Scanner sc = new Scanner(System.in);
        String s = sc.nextLine();
        String[] commands = s.split(" ");

        if (s.contains("SELECT count(*)  FROM  A, B WHERE A.RandomV > B.RandomV")) {
            count();
        } else if (commands[0].equals("SELECT") && commands[1].equals("Col2,")) {
            String dataset = commands[4];
            String function = commands[2];
            aggregate(dataset, function);
        } else {
            System.out.println("Command not found.");
            Main.run();
        }

        Main.run();
    }

    /**
     * prints the count of records whose random value from Dataset-A is greater than that the random value in records from Dataset-B
     * also prints execution time
     *
     * @throws FileNotFoundException
     */
    public static void count() throws FileNotFoundException {
        Stopwatch sw = new Stopwatch();
        int count = 0;

        //loop through all A files
        for (int Afilenum = 1; Afilenum < 100; Afilenum++) {

            String theString = "";
            int[] randomVals = new int[100];

            //go through each file
            File file = new File("Project3Dataset-A/A" + Afilenum + ".txt");
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();

            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }
            char[] charArray = theString.toCharArray();

            for (int i = 1; i <= 100; i++) {

                //create an array storing all records' randomV
                String randomVal = "";
                randomVal = randomVal + charArray[i * 40 - 7] + charArray[i * 40 - 6] + charArray[i * 40 - 5] + charArray[i * 40 - 4];
                randomVals[i - 1] = Integer.parseInt(randomVal);
            }

            for (int BfileNum = 1; BfileNum < 100; BfileNum++) {
                String BtheString = "";

                //go through each file
                File Bfile = new File("Project3Dataset-B/B" + BfileNum + ".txt");
                Scanner Bscanner = new Scanner(Bfile);
                BtheString = Bscanner.nextLine();

                while (Bscanner.hasNextLine()) {
                    BtheString = BtheString + "\n" + Bscanner.nextLine();
                }
                char[] BcharArray = BtheString.toCharArray();

                for (int i = 1; i <= 100; i++) {

                    //create an array storing all records' randomV
                    String randomVal = "";
                    randomVal = randomVal + BcharArray[i * 40 - 7] + BcharArray[i * 40 - 6] + BcharArray[i * 40 - 5] + BcharArray[i * 40 - 4];

                    for (int val : randomVals) {
                        if (val > Integer.parseInt(randomVal)) {
                            count++;
                        }
                    }
                }
            }
        }

        System.out.println("Qualifying record count: " + count);
        System.out.println("Execution time: " + sw.elapsedTime() + " ms");

    }

    /**
     * executes the aggregation query of SUM or AVG over the A or B data set
     *
     * @param dataset  data set the function is using, A or B
     * @param function the function being executed, SUM or AVG
     * @throws FileNotFoundException
     */
    public static void aggregate(String dataset, String function) throws FileNotFoundException {

        Stopwatch sw = new Stopwatch();
        Hashtable<Integer, Integer> hash = new Hashtable<Integer, Integer>();

        for (int fileNum = 1; fileNum < 100; fileNum++) {

            String theString = "";
            File file = new File("Project3Dataset-" + dataset + "/" + dataset + fileNum + ".txt");
            Scanner scanner = new Scanner(file);
            theString = scanner.nextLine();

            while (scanner.hasNextLine()) {
                theString = theString + "\n" + scanner.nextLine();
            }
            char[] charArray = theString.toCharArray();

            for (int i = 1; i <= 100; i++) {
                String randomV = "";
                randomV = randomV + charArray[i * 40 - 7] + charArray[i * 40 - 6] + charArray[i * 40 - 5] + charArray[i * 40 - 4];

                String name = "";
                name = name + charArray[i * 40 - 24] + charArray[i * 40 - 23] + charArray[i * 40 - 22];

                if (hash.get(Integer.parseInt(name)) == null) {
                    hash.put(Integer.parseInt(name), Integer.parseInt(randomV));
                } else {
                    int sum = hash.get(Integer.parseInt(name)) + Integer.parseInt(randomV);
                    hash.put(Integer.parseInt(name), sum);
                }
            }

        }

        if (function.contains("AVG")) {
            for (int i = 1; i <= 100; i++) {
                int avg = hash.get(i) / 99;
                hash.put(i, avg);
            }
        }

        for (int i = 1; i <= 100; i++) {
            if (i < 10) {
                System.out.println("Name00" + i + ", " + hash.get(i));
            } else if (i < 100) {
                System.out.println("Name0" + i + ", " + hash.get(i));
            } else {
                System.out.println("Name" + i + ", " + hash.get(i));
            }
        }

        System.out.println("Execution time: " + sw.elapsedTime() + " ms");

    }

}


