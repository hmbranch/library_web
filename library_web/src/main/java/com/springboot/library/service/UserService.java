package com.springboot.library.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.springboot.library.mapper.UserMapper;  // 이걸로 변경
import com.springboot.library.model.User;

@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;  // UserDaoImpl 대신 UserMapper 직접 사용
    
    // 로그인 검증
    public User login(String userId, String userPw) {
        return userMapper.findByUserIdAndPassword(userId, userPw);
    }
    
    // 회원가입
    public boolean register(User user) {
        try {
            if (userMapper.countByUserId(user.getUserId()) > 0) {
                return false;
            }
            userMapper.insertUser(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}