package com.springboot.library.mapper;

import com.springboot.library.model.Seat;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SeatMapper {
    
    // 모든 좌석 조회
    @Select("SELECT * FROM seats ORDER BY seat_id")
    @Results({
        @Result(property = "seatId", column = "seat_id"),
        @Result(property = "seatName", column = "seat_name"),
        @Result(property = "isOccupied", column = "is_occupied"),
        @Result(property = "arduinoSignal", column = "arduino_signal"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "reservationStart", column = "reservation_start"),
        @Result(property = "reservationEnd", column = "reservation_end"),
        @Result(property = "lastUpdated", column = "last_updated")
    })
    List<Seat> findAllSeats();
    
    // 특정 좌석 조회
    @Select("SELECT * FROM seats WHERE seat_id = #{seatId}")
    @Results({
        @Result(property = "seatId", column = "seat_id"),
        @Result(property = "seatName", column = "seat_name"),
        @Result(property = "isOccupied", column = "is_occupied"),
        @Result(property = "arduinoSignal", column = "arduino_signal"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "reservationStart", column = "reservation_start"),
        @Result(property = "reservationEnd", column = "reservation_end"),
        @Result(property = "lastUpdated", column = "last_updated")
    })
    Seat findBySeatId(@Param("seatId") Integer seatId);
    
    // 사용 가능한 좌석만 조회
    @Select("SELECT * FROM seats WHERE is_occupied = FALSE AND arduino_signal = FALSE ORDER BY seat_id")
    @Results({
        @Result(property = "seatId", column = "seat_id"),
        @Result(property = "seatName", column = "seat_name"),
        @Result(property = "isOccupied", column = "is_occupied"),
        @Result(property = "arduinoSignal", column = "arduino_signal"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "reservationStart", column = "reservation_start"),
        @Result(property = "reservationEnd", column = "reservation_end"),
        @Result(property = "lastUpdated", column = "last_updated")
    })
    List<Seat> findAvailableSeats();
    
    // 좌석 예약
    @Update("UPDATE seats SET is_occupied = TRUE, user_id = #{userId}, " +
            "reservation_start = NOW(), reservation_end = DATE_ADD(NOW(), INTERVAL #{hours} HOUR) " +
            "WHERE seat_id = #{seatId} AND is_occupied = FALSE AND arduino_signal = FALSE")
    int reserveSeat(@Param("seatId") Integer seatId, 
                   @Param("userId") String userId, 
                   @Param("hours") Integer hours);
    
    // 좌석 예약 해제
    @Update("UPDATE seats SET is_occupied = FALSE, user_id = NULL, " +
            "reservation_start = NULL, reservation_end = NULL " +
            "WHERE seat_id = #{seatId}")
    int cancelReservation(@Param("seatId") Integer seatId);
    
    // 아두이노 신호 업데이트
    @Update("UPDATE seats SET arduino_signal = #{signal} WHERE seat_id = #{seatId}")
    int updateArduinoSignal(@Param("seatId") Integer seatId, @Param("signal") Boolean signal);
    
    // 사용자별 예약 좌석 조회
    @Select("SELECT * FROM seats WHERE user_id = #{userId}")
    @Results({
        @Result(property = "seatId", column = "seat_id"),
        @Result(property = "seatName", column = "seat_name"),
        @Result(property = "isOccupied", column = "is_occupied"),
        @Result(property = "arduinoSignal", column = "arduino_signal"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "reservationStart", column = "reservation_start"),
        @Result(property = "reservationEnd", column = "reservation_end"),
        @Result(property = "lastUpdated", column = "last_updated")
    })
    List<Seat> findByUserId(@Param("userId") String userId);
    
    // 예약 연장
    @Update("UPDATE seats SET reservation_end = DATE_ADD(reservation_end, INTERVAL #{additionalHours} HOUR) " +
            "WHERE seat_id = #{seatId} AND user_id = #{userId} AND is_occupied = TRUE")
    int extendReservation(@Param("seatId") Integer seatId, 
                         @Param("userId") String userId, 
                         @Param("additionalHours") Integer additionalHours);
    
    // 만료된 예약 자동 해제
    @Update("UPDATE seats SET is_occupied = FALSE, user_id = NULL, " +
            "reservation_start = NULL, reservation_end = NULL " +
            "WHERE reservation_end < NOW() AND is_occupied = TRUE")
    int clearExpiredReservations();
}