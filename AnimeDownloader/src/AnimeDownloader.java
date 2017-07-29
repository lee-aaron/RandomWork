import java.io.IOException;
import java.util.*;

public class AnimeDownloader {

	public static void main(String[] args) throws IOException {
		Scanner scan = new Scanner(System.in);
		urlCrawler uC = new urlCrawler();
		while (true) {
			System.out.println("Choose an Option:" + "\n" + "  1. Add Anime to list" + "\n" + "  2. Download Anime"
					+ "\n" + "  3. Quit" + "\n");
			String option = scan.next();
			if (option.equalsIgnoreCase("1") || option.equalsIgnoreCase("Add Anime to list")) {
				while (true) {
					System.out.println("Would you like to add an anime? Y/N");
					String opt = scan.next();
					if (opt.equalsIgnoreCase("Y")) {
						System.out.println("Enter anime: (ex One Piece or Kimi No Na Wa)");
						String anime = scan.next();
						anime += scan.nextLine();
						if(uC.writeToFile(anime))
						{
							System.out.println("Anime already entered");
						} else {
							System.out.println("Anime successfully entered");
						}
					} else if (opt.equalsIgnoreCase("N")) {
						break;
					} else {
						System.out.println("Please enter a valid input");
					}
				}
			} else if (option.equalsIgnoreCase("2") || option.equalsIgnoreCase("Download Anime")) {
				uC.test();
			} else if (option.equals("3") || option.equalsIgnoreCase("Quit")) {
				break;
			} else {
				System.out.println("Please enter a valid input");
			}
		}
		scan.close();
	}

}
