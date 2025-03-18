public class TwitterTweetController {

	public TwitterStatus thisStatus { get; 
		set {
			System.debug(value);
			thisStatus = value;
		}
	 }
	
}