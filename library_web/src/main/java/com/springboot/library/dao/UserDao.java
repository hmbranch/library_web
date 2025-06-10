package com.springboot.library.dao;

import com.springboot.library.model.User;

public interface UserDao {
    
    // 로그인용 - 아이디와 비밀번호로 사용자 찾기
    User findByUserIdAndPassword(String userId, String userPw);
    
    // 회원가입용 - 사용자 등록
    void insertUser(User user);
    
    // 아이디 중복 체크
    int countByUserId(String userId);
    
    // 사용자 정보 조회
    User findByUserId(String userId);
}