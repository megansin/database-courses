import sun.tools.jar.CommandLine;

import java.io.*;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferPool bp = new BufferPool();
        //parameter inputted in program arguments in application configurations,
        //i.e. 3 was inputted as the parameter when testing
        bp.initialize(Integer.valueOf(args[0]));
        System.out.println("BufferPool with size " + bp.getBuffers().length + " initialized.");
        Main.run(bp);
    }

    public static void run(BufferPool bp) throws IOException {
        System.out.println("The program is ready for the next command (GET, SET, PIN, UNPIN)");
        Scanner sc = new Scanner(System.in);
        String s = sc.next();
        String[] command = s.split(" ");
        if(command[0].equals("GET")){
            bp.getRID(sc.nextInt());
            Main.run(bp);
        }
        if(command[0].equals("SET")){
            System.out.println("New record:");
            Scanner rec = new Scanner(System.in);
            char[] record = rec.nextLine().toCharArray();
            bp.setRID(sc.nextInt(), record);
            Main.run(bp);
        }
        if(command[0].equals("PIN")){
            bp.pinFID(sc.nextInt());
            Main.run(bp);
        }
        if(command[0].equals("UNPIN")){
            bp.unpinFID(sc.nextInt());
            Main.run(bp);
        }
    }

}