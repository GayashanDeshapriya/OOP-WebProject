package com.OOPWebProject.model;

public class User {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String role = "user";
    private String status = "active";
    private String createdDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    private String phone = "";
    private String address = "";

    public User() {}

    public User(int id, String firstName,String lastName, String email) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;

    }

    public User(String firstName, String email) {
    	this.firstName=firstName;
        this.email = email;

    }

    public User(String firstName, String email,String password) {
    	this.firstName=firstName;
        this.email = email;
        this.password = password;
    }

    public User(int id, String firstName, String email, String country, String password) {
        this.id = id;
        this.firstName=firstName;
        this.email = email;
        this.password = password;
    }

    public User(String firstName, String lastName, String email, String password) {
    	this.firstName=firstName;
    	this.lastName=lastName;
        this.email = email;
        this.password = password;
	}

	public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getfirstName() { return firstName; }
    public void setfirstName(String firstName) { this.firstName = firstName; }

    public String getlastName() { return lastName; }
    public void setlastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() {
        return role != null ? role : "user";
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status != null ? status : "active";
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }

    public String getPhone() {
        return phone != null ? phone : "";
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address != null ? address : "";
    }

    public void setAddress(String address) {
        this.address = address;
    }

}