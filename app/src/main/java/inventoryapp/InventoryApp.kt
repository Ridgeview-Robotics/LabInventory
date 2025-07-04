package Main

import android.Manifest
import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.google.zxing.integration.android.IntentIntegrator
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class MainActivity : AppCompatActivity() {
    private lateinit var dbHelper: DBHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        dbHelper = DBHelper(this)

        val scanButton = findViewById<Button>(R.id.scan_button)
        scanButton.setOnClickListener {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 1)
            IntentIntegrator(this).initiateScan()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data)
        if (result != null && result.contents != null) {
            val item = dbHelper.getItem(result.contents)
            if (item != null) {
                displayItemInfo(item)
            } else {
                Toast.makeText(this, "Item not found", Toast.LENGTH_SHORT).show()
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    private fun displayItemInfo(item: Item) {
        findViewById<TextView>(R.id.item_brand).text = "Brand: ${item.brand}"
        findViewById<TextView>(R.id.item_type).text = "Type: ${item.type}"
        findViewById<TextView>(R.id.item_status).text = "Status: ${item.status}"

        val checkInButton = findViewById<Button>(R.id.check_in_button)
        val checkOutButton = findViewById<Button>(R.id.check_out_button)

        checkInButton.setOnClickListener {
            dbHelper.updateItemStatus(item.id, "In", null)
            Toast.makeText(this, "Item checked in", Toast.LENGTH_SHORT).show()
            displayItemInfo(dbHelper.getItem(item.id)!!)
        }

        checkOutButton.setOnClickListener {
            val input = EditText(this)
            AlertDialog.Builder(this)
                .setTitle("Enter Name")
                .setView(input)
                .setPositiveButton("OK") { _, _ ->
                    val name = input.text.toString()
                    dbHelper.updateItemStatus(item.id, "Out", name)
                    Toast.makeText(this, "Item checked out to $name", Toast.LENGTH_SHORT).show()
                    displayItemInfo(dbHelper.getItem(item.id)!!)
                }
                .setNegativeButton("Cancel", null)
                .show()
        }

        // Placeholder for images
        val imageView1 = findViewById<ImageView>(R.id.image_view_1)
        val imageView2 = findViewById<ImageView>(R.id.image_view_2)

        // Replace with your PNGs
        // Example: imageView1.setImageBitmap(BitmapFactory.decodeResource(resources, R.drawable.image1))
        // Example: imageView2.setImageBitmap(BitmapFactory.decodeResource(resources, R.drawable.image2))
    }
}

// Database Helper
class DBHelper(context: Activity) : SQLiteOpenHelper(context, "InventoryDB", null, 1) {
    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE Items (id TEXT PRIMARY KEY, brand TEXT, type TEXT, status TEXT, checkedOutBy TEXT)")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS Items")
        onCreate(db)
    }

    fun getItem(id: String): Item? {
        val db = readableDatabase
        val cursor = db.rawQuery("SELECT * FROM Items WHERE id = ?", arrayOf(id))
        return if (cursor.moveToFirst()) {
            Item(
                id = cursor.getString(0),
                brand = cursor.getString(1),
                type = cursor.getString(2),
                status = cursor.getString(3),
                checkedOutBy = cursor.getString(4)
            )
        } else {
            null
        }
    }

    fun updateItemStatus(id: String, status: String, checkedOutBy: String?) {
        val db = writableDatabase
        db.execSQL("UPDATE Items SET status = ?, checkedOutBy = ? WHERE id = ?", arrayOf(status, checkedOutBy, id))
    }
}

// Data Class for Item
data class Item(
    val id: String,
    val brand: String,
    val type: String,
    val status: String,
    val checkedOutBy: String?
)
