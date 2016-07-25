package newSoundManager
{
public class JStrUnti
	{
		public function JStrUnti()
		{
		}


		//获取上一级文件路径
		public static  function getDimProUrl(str:String,count:int = 1):String
		{
			while(count--)
			{
				var LastStr:String= getUrlLastStr(str);
				var end:int = str.lastIndexOf(LastStr);
				str = str.slice(0,end-1);
			}
				return str;

		}

		//获取最后文件除后缀
		public static function getDimStr(str:String):String
		{
			var start:int = str.lastIndexOf("/");
			var end:int = str.lastIndexOf(".");
			var dim:String = str.slice(++start,end);
			return dim;
		}

		//获取最后文件名
		public static function getUrlLastStr(str:String):String
		{
			var index:int = str.lastIndexOf("/");
			var dim:String = str.slice(++index);
			return dim;
		}

		//获取后缀
		public static function getUrlSuffixStr(str:String):String
		{
			var index:int = str.lastIndexOf(".");
			var dim:String = str.slice(++index);
			return dim;
		}

		//替换后缀
		public static function replaceSuffixStr(str:String,newSur:String):String
		{
			var end:int = str.lastIndexOf(".");
			var dim1:String = str.slice(0,++end);
			var dim:String =  dim1 + newSur;
			return dim;
		}

		//替换最后字符串
		public static function replaceLastStr(str:String,newSuf:String):String
		{
			var dim:String =  str.replace(JStrUnti.getUrlLastStr(str),newSuf);
			return dim;
		}

	}
}