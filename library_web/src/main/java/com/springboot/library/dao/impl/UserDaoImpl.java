package com.springboot.library.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.springboot.library.dao.UserDao;
import com.springboot.library.mapper.UserMapper;
import com.springboot.library.model.User;

@Repository
public class UserDaoImpl implements UserDao {
    
    @Autowired
    private UserMapper userMapper;  // UserMapper를 주입받아야 함!
    
    @Override
    public User findByUserIdAndPassword(String userId, String userPw) {
        return userMapper.findByUserIdAndPassword(userId, userPw);
    }
    
    @Override
    public void insertUser(User user) {
        userMapper.insertUser(user);
    }
    
    @Override
    public int countByUserId(String userId) {
        return userMapper.countByUserId(userId);
    }
    
    @Override
    public User findByUserId(String userId) {
        return userMapper.findByUserId(userId);
    }
}