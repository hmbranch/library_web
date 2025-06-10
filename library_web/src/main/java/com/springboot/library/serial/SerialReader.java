package com.springboot.library.serial;

import com.fazecast.jSerialComm.SerialPort;
import org.springframework.stereotype.Component;


import java.util.Scanner;
@Component
public class SerialReader extends Thread {
    private boolean running = true;

    @Override
    public void run() {
        SerialPort port = SerialPort.getCommPort("/dev/ttyACM0");
        port.setBaudRate(9600);

        System.out.println("🔄 포트 열기 시도 중...");

        if (!port.openPort()) {
            System.err.println("❌ 포트 열기 실패: " + port.getSystemPortName());
            System.err.println("▶ 포트가 이미 열렸나요? " + port.isOpen());
            return;
        }

        System.out.println("✅ 시리얼 포트 연결됨");

        try (Scanner scanner = new Scanner(port.getInputStream())) {
            while (running && scanner.hasNextLine()) {
                String line = scanner.nextLine().trim();
                System.out.println("📥 아두이노 수신: " + line);
            }
        } catch (Exception e) {
            System.err.println("❗ 예외 발생: " + e.getMessage());
        }

        port.closePort();
        System.out.println("📴 포트 닫힘");
    }

    public void stopReader() {
        running = false;
    }
}

