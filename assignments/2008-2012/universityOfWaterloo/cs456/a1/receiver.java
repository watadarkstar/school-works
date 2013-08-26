
import java.io.*;
import java.net.*;
import java.lang.*;
import java.util.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public class receiver{
	String dHost;	// domain name of destination
	int dPort;		// destination port
	int lPort;		// local port
	String file;	// name of output file
	int nextseqnum;	// sequence number
	String output;	// characters that read from sender
	DatagramSocket clientSocket; // socket for sending ack packets
	DatagramSocket receiveSocket; // socket for receiving packets from sender
	InetAddress IPAddress; // IP address
	Vector<packet> packetVector; // keep the most recent packets received

	FileOutputStream arrival, outputfile;

	receiver (String arg1, String arg2, String arg3, String arg4){
		try{
			
			dHost = arg1;
			dPort = Integer.parseInt(arg2);
			lPort = Integer.parseInt(arg3);
			file = arg4;
			createFile(file);
			nextseqnum = 1;

			// create socket and IP
			IPAddress = InetAddress.getByName(dHost); //
			clientSocket = new DatagramSocket();
			receiveSocket = new DatagramSocket(lPort);
			packetVector = new Vector<packet>();	    

		}catch (Exception e){
			System.err.println("Error in initialization");
			System.exit(1);
		}
	}
	
	public boolean checkSeq_and_writeData(packet p) throws Exception{
		try{
			//verify the sequence number
			if(p.getSeqNum() == nextseqnum%32){
				//extract data from packet
				String data = new String(p.getData());
				//append new data to the old data
				output = output+data;	
				
				
				
				//invoke seqence number
				nextseqnum++;
				// keep the recent packets
				if(packetVector.size() < 10){
					packetVector.addElement(p);
				}else{
					packetVector.removeElementAt(0);
					packetVector.addElement(p);
				}
				return true;
			}
			return false;
		}catch (Exception e){
			System.err.println("Error in checkSeq and writeData");
		}
		return false;
	}

	private void createFile(String file) throws Exception{
		//create a new file
		try{
			arrival = new FileOutputStream ("arrival.log");
			outputfile = new FileOutputStream (file);
		}
		catch (Exception e){
			System.err.println("Error in creating file");
			System.exit(1);
		}
	}

	// 0 acknowledgement
	// 2 EOT
	// sending acknowledgement packet back to sender
	public void send(int type, int seqNum) throws Exception{
		try{
			byte[] sendData = new byte[512];
			//if receiving a data packet
			if(type == 0){
				packet ackPacket = packet.createACK(seqNum);
				sendData = ackPacket.getUDPdata();
			//if receiving and EOT packet
			}else if(type == 2){
				packet EOTPacket = packet.createEOT(seqNum);
				sendData = EOTPacket.getUDPdata();
			
			}else {
				System.err.println("Error in send");
				System.exit(1);
			}
			//return acknowledgement packet back to sender
			DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, dPort);
			clientSocket.send(sendPacket);

		}catch (Exception e){
			System.err.println("Error in send");
		}
	}

	//receiving packet from sender
	public void receive() throws Exception{
		
		try{
			byte[] receiveData = new byte[512];
			DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
			//recieve packet from socket
			receiveSocket.receive(receivePacket);
			
			packet dataPacket = packet.parseUDPdata(receiveData);
			//write the Sequence number to arrival.log
			new PrintStream(arrival).println (dataPacket.getSeqNum());

			// check type
			if(dataPacket.getType() == 1){

				// expecting packet received
				if(checkSeq_and_writeData(dataPacket)){
					send(0, dataPacket.getSeqNum());

					// same packet receive again, resend ack
				}else if(packetVector.size() > 0){
					for(int i = 0; i<packetVector.size(); i++){
						if(packetVector.elementAt(i).getSeqNum() == dataPacket.getSeqNum()){
							send(0, dataPacket.getSeqNum());
							break;
						}
					}
					
				}else{
					// discard packet, do nothing
				}

			}else if(dataPacket.getType() == 2){
				// wrap up if the packet is EOT type
				send(2, dataPacket.getSeqNum());

				new PrintStream(outputfile).println (output);
				
				
				System.exit(0);

			}else {
				// discard packet, do nothing
			}
		}catch (Exception e){
			System.err.println("Error in receive()");
		}
	}

	
	public static void main(String[] args){
		
		// Read arguments
		if(args.length != 4){
			System.err.println("Bad arguments");
			System.exit(1);
		}
		receiver r = new receiver(args[0], args[1], args[2], args[3]);
		
		try{
			while(true){
				//infinite loop to recieve packet 
				r.receive();
			}
		}catch (Exception e){
			System.err.println("Error in main");
			System.exit(1);
		}

		System.exit(0);
	}
	
}
