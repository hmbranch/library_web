package com.springboot.library.user;

import com.springboot.library.model.Seat;
import com.springboot.library.model.User;
import com.springboot.library.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
    
    @Autowired
    private SeatService seatService;
    
    // 마이페이지 메인
    @GetMapping("")
    public ModelAndView myPage(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        // 현재 예약 정보 조회
        List<Seat> myReservations = seatService.getUserReservations(loginUser.getUserId());
        
        // 만료된 예약 자동 정리
        seatService.clearExpiredReservations();
        
        ModelAndView mav = new ModelAndView("mypage/index");
        mav.addObject("loginUser", loginUser);
        mav.addObject("myReservations", myReservations);
        
        return mav;
    }
    
    // 예약 연장
    @PostMapping("/extend")
    public ModelAndView extendReservation(@RequestParam Integer seatId, 
                                         @RequestParam Integer additionalHours,
                                         HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        boolean success = seatService.extendReservation(seatId, loginUser.getUserId(), additionalHours);
        
        if (success) {
            return new ModelAndView("redirect:/mypage?success=extended");
        } else {
            return new ModelAndView("redirect:/mypage?error=extend_failed");
        }
    }
    
    // 예약 취소
    @PostMapping("/cancel")
    public ModelAndView cancelMyReservation(@RequestParam Integer seatId, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return new ModelAndView("redirect:/library/login");
        }
        
        // 내 예약인지 확인
        Seat seat = seatService.getSeatById(seatId);
        if (seat == null || !loginUser.getUserId().equals(seat.getUserId())) {
            return new ModelAndView("redirect:/mypage?error=not_your_reservation");
        }
        
        boolean success = seatService.cancelReservation(seatId);
        
        if (success) {
            return new ModelAndView("redirect:/mypage?success=cancelled");
        } else {
            return new ModelAndView("redirect:/mypage?error=cancel_failed");
        }
    }
    
    // 예약 현황 API (AJAX용)
    @GetMapping("/api/status")
    @ResponseBody
    public List<Seat> getMyReservationStatus(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        if (loginUser == null) {
            return List.of(); // 빈 리스트 반환
        }
        
        return seatService.getUserReservations(loginUser.getUserId());
    }
}
