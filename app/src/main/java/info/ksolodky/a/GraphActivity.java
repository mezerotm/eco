package info.ksolodky.a;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;

public class GraphActivity extends AppCompatActivity {

    LineGraphSeries<DataPoint> series;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_graph);

        final Button btAddNew = (Button) findViewById(R.id.btAdd);
        double x, y;
        x = -0.1;

        GraphView graph = (GraphView) findViewById(R.id.graph);
        series = new LineGraphSeries<DataPoint>();

        for (int i = 0; i < 100; i++)
        {
            x = x + 0.1;
            y = Math.tan(x);
            series.appendData(new DataPoint (x, y), true, 100);
        }
        graph.addSeries(series);

        btAddNew.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(GraphActivity.this, LocationActivity.class);
                GraphActivity.this.startActivity(intent);
            }
        });

    }

}