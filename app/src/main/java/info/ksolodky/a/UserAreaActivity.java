package info.ksolodky.a;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;

public class UserAreaActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_area);

        /*
        Intent intent = getIntent();
        String name = intent.getStringExtra("name");
        String email = intent.getStringExtra("email");
        String firstName = intent.getStringExtra("firstName");

        TextView tvWelcomeMessage = (TextView) findViewById(R.id.tvWelcomeMessage);
        EditText etEmail = (EditText) findViewById(R.id.etEmail);
        EditText etFirstName = (EditText) findViewById(R.id.etFirstName);

        // Display user details
        String message = "Welcome, " + name + "! Please confirm all information before proceeding.";
        tvWelcomeMessage.setText(message);
        etEmail.setText(email);
        etFirstName.setText(firstName);
        */

        Intent intent = new Intent(UserAreaActivity.this, LocationActivity.class);
        UserAreaActivity.this.startActivity(intent);
    }
}
