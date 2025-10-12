package com.OOPWebProject.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.UserDAO;
import com.OOPWebProject.model.User;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "login";
        }

        try {
            switch (action) {
                case "register":
                    registerUser(request, response);
                    break;
                case "login":
                    loginUser(request, response);
                    break;
                case "logout":
                    logoutUser(request, response);
                    break;
                default:
                    response.sendRedirect("login.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
        				try {
				logoutUser(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				throw new ServletException(e);
			}
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String country = request.getParameter("country");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            country == null || country.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("country", country);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("errorMessage", "Email already registered!");
            request.setAttribute("name", name);
            request.setAttribute("country", country);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Create new user
        User newUser = new User(name, email, country, password);
        userDAO.insertUser(newUser);

        // Set success message and redirect to login
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Registration successful! Please login.");
        response.sendRedirect("login.jsp");
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation
        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Email and password are required!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Validate user
        User user = userDAO.validateUser(email, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());

            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void logoutUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect("login.jsp");
    }
}
