package info.ksolodky.a;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;


public class UserActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user);

        URL url = null;
        HttpURLConnection urlConnection = null;

        try {
            url = new URL("http://96.32.80.7/users?session_id=bb22f5df43b478d3a9659414a4173a2ba9a39f26f9bccac41c5d1de9e2ee5028&email_address=true");

            urlConnection = (HttpURLConnection) url.openConnection();
            InputStream in = new BufferedInputStream(urlConnection.getInputStream());

            String collection = getStringFromInputStream(in);
            final TextView tvJson = (TextView) findViewById(R.id.tvJson);
            tvJson.setText(collection);

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            urlConnection.disconnect();
        }
    }

        public static String getStringFromInputStream(InputStream stream) throws IOException
        {
            int n = 0;
            char[] buffer = new char[1024 * 4];
            InputStreamReader reader = new InputStreamReader(stream, "UTF8");
            StringWriter writer = new StringWriter();
            while (-1 != (n = reader.read(buffer))) writer.write(buffer, 0, n);
            return writer.toString();
        }




    }
