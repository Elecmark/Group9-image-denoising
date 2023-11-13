package user;

import model.UserModel;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/userDetail")
public class UserDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取用户名
        String username = request.getParameter("username");

        // 获取数据库连接
        Connection connection = null;
        try {
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/testdb", "root", "214588Pdh");
        } catch (SQLException e) {
            e.printStackTrace();
            // 处理数据库连接异常
            // 这里可以根据实际情况选择返回错误信息或抛出自定义异常，中止代码执行
            return;
        }

        // 查询用户信息
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        UserModel user = null;
        try {
            String sql = "SELECT * FROM Staffs WHERE username = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, username);

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user = new UserModel();
                user.setUsername(resultSet.getString("username"));
                user.setRegistrationTime(resultSet.getString("registration_time"));
                user.setTelephone(resultSet.getString("tel"));
                user.setAge(resultSet.getString("age"));
                //user.setAvatarUrl(resultSet.getString("avatar_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // 处理数据库查询异常
            // 这里可以根据实际情况选择返回错误信息或抛出自定义异常，中止代码执行
            return;
        } finally {
            // 关闭资源
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (statement != null) {
                    statement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                // 处理资源关闭异常
                // 这里可以选择返回错误信息或抛出自定义异常
            }
        }

        // 将用户信息传递给userDetail.jsp进行显示
        request.setAttribute("USER_INFO", user);
        request.getRequestDispatcher("userDetail.jsp").forward(request, response);
    }
}
