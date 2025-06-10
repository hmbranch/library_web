package com.springboot.library.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springboot.library.model.User;
import com.springboot.library.service.SeatService;
import com.springboot.library.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/library")
public class UserController {
    
    @Autowired
    private UserService userService;
    @Autowired
    private SeatService seatService;
    
    @GetMapping(value="")
    public ModelAndView home(HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        
        ModelAndView mav = new ModelAndView("user/index");
        if (loginUser != null) {
            mav.addObject("loginUser", loginUser); // 로그인 정보 추가
            
            SeatService.SeatStats stats = seatService.getSeatStats();
            mav.addObject("stats", stats);
        }
        return mav;
    }
    
    // 로그인 후 페이지 이동
    @PostMapping(value="/login")
    public ModelAndView loginProcess(@RequestParam String userId, @RequestParam String userPw, HttpSession session) {
        
        User user = userService.login(userId, userPw);
        
        if (user != null) {
            // 로그인 성공
            session.setAttribute("loginUser", user);
            ModelAndView mav = new ModelAndView("redirect:/library"); // 기존 홈으로 리다이렉트
            return mav;
        } else {
            // 로그인 실패
            ModelAndView mav = new ModelAndView("user/login");
            mav.addObject("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return mav;
        }
    }
    
    @GetMapping(value="/login")
    public ModelAndView login() {
        ModelAndView mav = new ModelAndView("user/login");
        return mav;
    }
    
    // 회원가입 페이지
    @GetMapping("/register")
    public ModelAndView registerPage() {
        ModelAndView mav = new ModelAndView("user/register");
        return mav;
    }
    
    // 회원가입 처리
    @PostMapping(value="/register")
    public ModelAndView register(@RequestParam String userId,@RequestParam String userPw,@RequestParam String name) {
        
        User user = new User(userId, userPw, name);  // 생성자 사용
        
        if (userService.register(user)) {
            // 회원가입 성공
            ModelAndView mav = new ModelAndView("user/login");
            mav.addObject("success", "회원가입이 완료되었습니다. 로그인해주세요.");
            return mav;
        } else {
            // 회원가입 실패
            ModelAndView mav = new ModelAndView("user/register");
            mav.addObject("error", "이미 존재하는 아이디이거나 회원가입에 실패했습니다.");
            return mav;
        }
    }
    
    // 로그아웃
    @GetMapping("/logout")
    public ModelAndView logout(HttpSession session) {
        session.invalidate();
        ModelAndView mav = new ModelAndView("redirect:/library/login");
        return mav;
    }
}