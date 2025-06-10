package com.springboot.library.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class User {
	private Integer userIdx;
    private String userId;
    private String userPw;
    private String name;
    
    // 로그인용 생성자
    public User(String userId, String userPw) {
        this.userId = userId;
        this.userPw = userPw;
    }
    
    // 회원가입용 생성자
    public User(String userId, String userPw, String name) {
        this.userId = userId;
        this.userPw = userPw;
        this.name = name;
    }
}
