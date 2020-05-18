using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Data.SqlClient;
using System.Data;

using FindAService_WebForm.Models;

namespace FindAService_WebForm.Controllers
{
    public class UserAuthenticationController
    {

        //public void AddAuthentication(Guid user_ID, string email, string password, int userType)
        //{
        //    SqlConnection Connection = db.GetConnection();
        //    SqlCommand InsertCommand = new SqlCommand("Insert Into UserAuthentications(User_ID, Email, Password, UserType)values(@User_ID, @Email, @Password, @UserType)", Connection);

        //    InsertCommand.Parameters.AddWithValue("@User_ID", user_ID);
        //    InsertCommand.Parameters.AddWithValue("@Email", email);
        //    InsertCommand.Parameters.AddWithValue("@Password", password);
        //    InsertCommand.Parameters.AddWithValue("@UserType", userType);

        //    Connection.Open();
        //    InsertCommand.ExecuteNonQuery();
        //}

        //public UserAuthentication Login(string email, string password)
        //{
        //    SqlConnection Connection = db.GetConnection();
        //    SqlCommand GetCommand = new SqlCommand("Select Email, Password, UserType From UserAuthentications Where Email = @Email and Password = @Password and isApproved = 'true'", Connection);
        //    GetCommand.Parameters.AddWithValue("@Email", email);
        //    GetCommand.Parameters.AddWithValue("@Password", password);

        //    Connection.Open();
        //    SqlDataReader reader = GetCommand.ExecuteReader();
        //    if (reader.Read())
        //    {
        //        UserAuthentication AU = new UserAuthentication();
        //        AU.Email = reader["Email"].ToString();
        //        AU.Password = reader["Password"].ToString();
        //        //AU.UserType = (int)reader["UserType"];
        //        return AU;
        //    }
        //    else
        //    {
        //        return null;
        //    }
        //}

        //public UserAuthentication CheckPassword(string email)
        //{
        //    SqlConnection Connection = db.GetConnection();
        //    SqlCommand GetCommand = new SqlCommand("Select Password From UserAuthentications Where Email = @Email", Connection);
        //    GetCommand.Parameters.AddWithValue("@Email", email);

        //    Connection.Open();
        //    SqlDataReader reader = GetCommand.ExecuteReader();
        //    if (reader.Read())
        //    {
        //        UserAuthentication AU = new UserAuthentication();
        //        AU.Password = reader["Password"].ToString();
        //        return AU;
        //    }
        //    else
        //    {
        //        return null;
        //    }

        //}

    }
}
