import java.io.*;
import java.util.Scanner;

public class Frame {
    private char[] content;
    private boolean dirty, pinned;
    private int blockID, fileID;

    public Frame(){
        this.dirty = false;
        this.pinned = false;
        this.blockID = -1;
        this.fileID = -1;
    }

    public char[] getContent() {
        return content;
    }

    public void setContent(char[] content) {
        this.content = content;
    }

    public boolean isDirty() {
        return dirty;
    }

    public void setDirty(boolean dirty) {
        this.dirty = dirty;
    }

    public boolean isPinned() {
        return pinned;
    }

    public void setPinned(boolean pinned) {
        this.pinned = pinned;
    }

    public int getBlockID() {
        return blockID;
    }

    public void setBlockID(int blockID) {
        this.blockID = blockID;
    }

    public int getFileID(){
        return fileID;
    }

    public void setFileID(int fileID){
        this.fileID = fileID;
    }

    /**
     * reads file content into frame's content array
     * @param fileID file id for desired file to be read into frame
     * @throws FileNotFoundException
     */
    public void readFile(int fileID) throws FileNotFoundException {
        String theString = "";
        File file = new File("Project1/F" + fileID + ".txt");
        Scanner scanner = new Scanner(file);
        theString = scanner.nextLine();
        while (scanner.hasNextLine()) {
            theString = theString + "\n" + scanner.nextLine();
        }
        char[] charArray = theString.toCharArray();
        setContent(charArray);
        this.fileID = fileID;
        this.dirty = false;
        this.pinned = false;
    }

    /**
     * replaces files' current text with frame's current content char[]
     * @throws IOException
     */
    public void writeFile() throws IOException {
        File file = new File("Project1\\F" + fileID+".txt");
        BufferedWriter writer = new BufferedWriter(new FileWriter(("Project1\\\\F"+fileID+".txt"), false));
        writer.write(this.content);
        writer.close();
    }

    /**
     * retrieves length 40 of record at the specified record id
     * @param rid record id of record you want to retrieve
     * @return char[] of length 40
     */
    public char[] getRecord(int rid){
        int charIndex = rid-((fileID-1) *100)-1;
        char[] record = new char[40];
        for (int j = 0; j < 40; j++){
            int i = (charIndex*40+j);
            record[j] = content[i];
        }
        return record;
    }

    /**
     * assuming new record is always different form old record, sets record at given record id to the inputted new record
     * @param rid record id desired to be set to a different record
     * @param newRecord new record to be put into specified record
     */
    public void setRecord(int rid, char[] newRecord){
        int charIndex = rid-((fileID-1) *100)-1;
        for (int j = 0; j < 40; j++){
            int i = (charIndex*40+j);
            content[i] = newRecord[j];
        }
        this.dirty = true;
    }
}