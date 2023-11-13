package model;

public class UserModel {
	private String username;
	private String password;
    private String tel;
    private String age;
    private String registration_time;
	private String role;
	private String avatarUrl;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
    public String getTelephone() {
        return tel;
    }

    public void setTelephone(String tel) {
        this.tel = tel;
    }
	
    public String getAge() {
        return age;
    }

	public void setAge(String age) {
        this.age = age;
	}
    
	public String getRegistrationTime() {
        return registration_time;
    }

	public void setRegistrationTime(String registration_time) {
        this.registration_time = registration_time;
	}
	
	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}
	
	public String getAvatarUrl() {
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl) {
		this.avatarUrl = avatarUrl;
	}
}

