import java.io.*;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.net.*;
import java.lang.*;
import java.util.*;

public class sender{

	String dHost;	// domain name of destination
	int dPort;		// destination port
	int lPort;		// local port
	String file;	// file to be sent
	FileOutputStream seqnum;
	FileOutputStream ack;
	int windowSize;
	int stringLength;	// number of byte for each string to put inside packet
	Vector<packet> packetVector; // window
	int base;		// base
	int nextseqnum;	// next sequence num
	InetAddress IPAddress; // IP address
	DatagramSocket clientSocket; // socket for sending
	DatagramSocket receiveSocket; // socket for receiving ack
	Timer timer;	// timer
	TimerTask timeout;  // timeout
	BufferedReader buffer; // buffer that stores file's content
	boolean EOT; 	// check whether EOT is received
	boolean BufferEmpty; // check whether we have finished reading the file
	boolean timerInUse; // check whether timer is running
	////// sender //////
	sender (String arg1, String arg2, String arg3, String arg4){
		try{
			// initialize
			dHost = arg1;
			dPort = Integer.parseInt(arg2);   
			lPort = Integer.parseInt(arg3);   
			file = arg4;                      
			windowSize = 10;                  
			stringLength = 50;          
			base = 1;                         
			nextseqnum = 1;
			
			packetVector = new Vector<packet>(); 

			timer = new Timer();
			EOT = false;
			BufferEmpty = false;
			timerInUse = false;

			timeout = new TimerTask(){ //contruct a new timeout object
				public void run(){
					try{
						redo();
					}catch (Exception e){
						System.err.println("error in timertask");
						System.exit(1);
					}
				}
			};

			// create socket and IP
			clientSocket = new DatagramSocket();
			IPAddress = InetAddress.getByName(dHost);
			receiveSocket = new DatagramSocket(lPort);

			// initialize buffer
			FileInputStream fstream = new FileInputStream(file);
			DataInputStream in = new DataInputStream(fstream);
			buffer = new BufferedReader(new InputStreamReader(in));

			createFile(); 

		}catch (Exception e){
			System.err.println("Error in initialization");
			System.exit(1);
		}
	}

	//initialization of log files
	private void createFile() throws Exception{
		try{
			//create log files with required name
			seqnum = new FileOutputStream ("seqnum.log"); 
			ack = new FileOutputStream ("ack.log");
		}

		catch (Exception e){
			System.err.println("Error in creating log files");
			System.exit(1);
		}

	}

	// start_timer
	/*
    assign what tasks should timeout performs when it is triggered
	1) should resent all packets from basic to nextseqnum-1, see chp3-46
	2) restart the timer
	 */
	private void start_timer() throws Exception{
		//synchronized(timeout){
		timeout.cancel();
		timeout = new TimerTask(){
			public void run(){
				try {
					redo();
				}
				catch (Exception e){
					System.err.println("Error in start_timer");
					System.exit(1);
				}
			}
		};
		timer.schedule(timeout, 500);
		//}
	}

	//resend the lost packet and the packets after it
	private void redo() throws Exception{
		for(int i = 0; i<packetVector.size(); i++){
			byte[] byteData = new byte[512];
			// scan the vector to obtain UPDdata
			byteData = packetVector.elementAt(i).getUDPdata();
			//resend send the data 
			DatagramPacket sendPacket = new DatagramPacket(byteData, byteData.length, IPAddress, dPort);
			clientSocket.send(sendPacket);
						
			// resend sequence number
			new PrintStream(seqnum).println (packetVector.elementAt(i).getSeqNum());
		}
		start_timer(); //reset timer
	}


	////// receive ///////
	/* 
    receive ack packets
	1) convert into bytes
	2) check type
	3) assign base
	4) stop/start timer, see chp3-46
	 */
	public void receive() throws Exception{
		while(true){
			byte[] receiveData = new byte[512];
			DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
			receiveSocket.receive(receivePacket);
			packet ackPacket = packet.parseUDPdata(receiveData);

			new PrintStream(ack).println (ackPacket.getSeqNum()); //write the Sequence Number to file

			if(ackPacket.getType() == 0 && packetVector.size()>0){
				// delete acknowledged packets in the window
				for(int i = 0; i<packetVector.size(); i++){
					//if the acknoweldge number is the same with the sequence number in the vector, we remove it
					if(packetVector.elementAt(i).getSeqNum() == ackPacket.getSeqNum()){
						for(int j = i; j>=0; j--){
							packetVector.removeElementAt(j);
						}
						break;
					}
				}

			}
			// case for acknowedge type is EOT
			else if(ackPacket.getType() == 2){
				EOT = true;
				clientSocket.close();
				receiveSocket.close();
				System.exit(0);
			}
			
			//if the vector size is greater than 0, we invoke timer method 
			if(packetVector.size() > 0){	
				start_timer();
			}
			else {
			//stop the timer all anticipating acknowledgment are recieved
				timeout.cancel();
			}

		}
	}



	// read characters from "filename" and return a string with length of 500
	/*
	1) fetch the first 500 characters from buffer
	2) check whether buffer is empty (return null if empty)
	3) check cases when buffer size is less than 500
	 */
	public String read_file(String filename) throws Exception{
		String str;
		int c = 0;
		int i = 0;
		char charArray[] = new char[stringLength];
		
		while( (i < stringLength) && (c = buffer.read()) != -1 ){
			//read from input file
			charArray[i++] = (char)c;
		}
		if(c == -1 && i == 0){
			//reach the end of the file
			return null;
			
		}else if(i != stringLength){
			
			char charArrayLast[] = new char[i];
			for(int j = 0; j<i; j++){
				//filter out the emtpy slot of charArray
				charArrayLast[j] = charArray[j];
			}
			//cast the array into string
			str = new String(charArrayLast);
			return str;
		}

		str = new String(charArray);
		return str;
	}


	/////// send data //////
	/*
	1) check window size
	2) if window size is okay, create packet inside the array
	3) send packet
	 */
	public void send(String data) throws Exception{
		try {
			//the vector should have the size of windowSzie
			if (packetVector.size() < 10){
				packet instance = packet.createPacket(nextseqnum, data); 
				//add the ready-to-send packet to the vector
				packetVector.addElement(instance);

				byte[] byteData = new byte[512];
				//obtain data
				byteData = instance.getUDPdata();
				//send data
				DatagramPacket sendPacket = new DatagramPacket(byteData, byteData.length, IPAddress, dPort);
				clientSocket.send(sendPacket);
				//write the Sequence number to the seqnum.log			
				new PrintStream(seqnum).println (instance.getSeqNum());
				
				if (packetVector.size() > 1 && !timerInUse){
					timerInUse = true;
					start_timer();
				}
				nextseqnum++;

			}else {
				// refuse_data(data);
			}
		}catch (Exception e){
			System.err.println("Error in send");
			System.exit(1);
		}
	}



	public void start(){
		try {
			//create a new thread ojbect 
			Thread receiveThread = new Thread(){
				public void run(){
					try {
						receive();
					}catch (Exception e){
						System.err.println("Error in thread (receive)");
						System.exit(1);
					}
				}
			};
			receiveThread.start();

			String str;
			//reading data from input file
			while((str = read_file(file)) != null){
				// check whether window is full
				while(packetVector.size() == windowSize){
					Thread.sleep(100);
				}
				//send data
				send(str);
			}

			// wait until all packets are sent and acknowledged
			while(packetVector.size() != 0){
				Thread.sleep(300);
			}

			// send EOT
			packet EOTPacket = packet.createEOT(nextseqnum);
			nextseqnum++;
			byte[] byteEOT = new byte[512];
			byteEOT = EOTPacket.getUDPdata();
			DatagramPacket sendPacket = new DatagramPacket(byteEOT, byteEOT.length, IPAddress, dPort);
			clientSocket.send(sendPacket);
			
			// resend sequence number
			new PrintStream(seqnum).println (EOTPacket.getSeqNum());	
			
			// wait until EOT received from receiver
			while(!EOT){
				Thread.sleep(500);
			}

			//close sockets and log files
			clientSocket.close();
			receiveSocket.close();
			seqnum.close();
			ack.close();

		}catch (Exception e){
			System.err.println("Error in sending and receiving packets");
			System.exit(1);
		}
	}


	// main
	public static void main(String[] args){

		// Read arguments
		if(args.length != 4){
			System.err.println("Bad arguments");
			System.exit(1);
		}
		sender s = new sender(args[0], args[1], args[2], args[3]);
		Vector<String> v = new Vector<String>(6);

		// send file and receive ack
		try{

			s.start();

		}catch (Exception e){
			System.err.println("Error in sending and receiving packets");
			System.exit(1);
		}

		System.exit(0);
	}
}
