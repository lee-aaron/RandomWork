import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.SwingUtilities;
import javax.swing.Timer;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import org.json.*;

public class BitcoinPrice {
	
	private static Data data = new Data();
	private static DefaultTableModel model;
	private JTable table;
	private String[] columns;
	private String[][] oldData;
	private String[][] newData;
	
	private void runGUI() throws JSONException, Exception 
	{
		JFrame frame = new JFrame("Bitcoin GUI - Blockchain");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        initComponents(frame);
        frame.pack();
        frame.setVisible(true);
        //Runs every 2 seconds
        new Timer(2000, new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					updateTable();
					//Updates values in the table
					for(int i = 0; i < newData.length; i++)
					{
						model.setValueAt(newData[i][1], i, 1);
						model.setValueAt(newData[i][2], i, 2);
						model.setValueAt(newData[i][3], i, 3);
						model.setValueAt(newData[i][4], i, 4);
					}
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
        }).start();
        
	}
	
	private void initComponents(JFrame frame) throws JSONException, Exception 
	{

		columns = data.getHeader();
        newData = data.getData();
        model = new DefaultTableModel(newData, columns);
        table = new JTable(model);
        frame.getContentPane().add(new JScrollPane(table));
    }
	
	private void updateTable() throws JSONException, Exception
	{
		oldData = newData;
        newData = data.getData();
	}
	
	public static void main(String[] args) throws Exception {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                try {
					new BitcoinPrice().runGUI();
				} catch (Exception e) {
					e.printStackTrace();
				}
            }
        });

    }
}
