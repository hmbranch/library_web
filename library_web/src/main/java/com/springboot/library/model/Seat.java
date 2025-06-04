package com.springboot.library.model;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Seat {
    private Integer seatId;              
    private String seatName;             
    private Boolean isOccupied;          
    private Boolean arduinoSignal;       
    private String userId;               
    private Date reservationStart;       
    private Date reservationEnd;         
    private Date lastUpdated;            
    
    // 좌석 상태를 확인하는 편의 메소드들
    public boolean isAvailable() {
        return !isOccupied; // 단순하게 예약 여부만 체크
    }
    
    public boolean isReserved() {
        return isOccupied && userId != null;
    }
    
    public boolean hasArduinoDetection() {
        return arduinoSignal != null && arduinoSignal;
    }
    
    // 수정된 상태 텍스트
    public String getStatusText() {
        if (!isOccupied) {
            return "사용 가능";
        } else if (isReserved()) {
            return "사용 중"; // 예약된 상태는 바로 "사용 중"
        } else {
            return "점검 중";
        }
    }
    
    // 수정된 CSS 클래스
    public String getStatusClass() {
        if (!isOccupied) {
            return "available";
        } else if (isReserved()) {
            return "occupied"; // 예약된 상태는 바로 "occupied"
        } else {
            return "maintenance";
        }
    }
}