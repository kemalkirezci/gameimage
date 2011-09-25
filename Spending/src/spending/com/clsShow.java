package spending.com;

import java.util.ArrayList;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

public class clsShow extends Activity{

	private static final String TAG = clsShow.class.getSimpleName();
	EditText edtAmountFrom;
	Button btnBack;
	Button btnHome;

	@Override
	public void onCreate(Bundle saved){
		super.onCreate(saved);
		setContentView(R.layout.search);
		try{	
			Bundle nBundle  = getIntent().getExtras();
			ArrayList<clsData> myArray = nBundle.getParcelableArrayList("SPENDING");
			if(myArray == null){
				Log.i(TAG, "***** Khong co du lieu ");
				return;
			}
			
			final ListView lv1 = (ListView) findViewById(R.id.ListView01);
			lv1.setAdapter(new clsCustomBaseAdapter(this, myArray));

			// btnBack = (Button)findViewById(R.id.btnBack);
			// btnHome = (Button)findViewById(R.id.btnHome);
			
			// btnBack.setOnClickListener(new View.OnClickListener(){
				// public void onClick(View view){
				    // Intent iData = new Intent();
					// iData.putExtra( "BACK", "search" );
					// setResult( android.app.Activity.RESULT_OK, iData );					
					// finish();
				// }
			// });
			
			// btnHome.setOnClickListener(new View.OnClickListener(){
				// public void onClick(View view){
					// Intent iData = new Intent();
					// iData.putExtra( "BACK", "home" );
					// setResult( android.app.Activity.RESULT_OK, iData );
					// finish();
				// }
			// });
		}catch(Exception ex){
			Log.i(TAG, "***** onCreate() Error: " + ex.getMessage());
		}
	}

}