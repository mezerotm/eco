package info.ksolodky.a;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class LocationActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location);

        final Button btAddDevice = (Button) findViewById(R.id.btAdd);

        btAddDevice.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent loginIntent = new Intent(LocationActivity.this, DeviceActivity.class);
                LocationActivity.this.startActivity(loginIntent);
            }
        });

    }
}
