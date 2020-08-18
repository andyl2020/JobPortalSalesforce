public with sharing class JobApiResultTemplate {
    //variable names MUST MATCH API RESPONSE

    public class JobTemplate{
        public String href; //"ca.indeed.com/cmp/Ttec",
        public boolean isSponsored; //true,
        public String company; //"TTEC",
        public String location; //"Not specified",
        public String salary; //"TTEC\n\n\n\n\n3.5\n\n\n\n\n\n\n\nPrince Edward Island",
        public String summary; //"Not specified"
        public String title; 
        public String datePosted; //does not exist in all fields 
    }

    public class GeocodeTemplate{
        public Double lat; //64.2008413,
        public Double lng; //-149.4936733
    }

    public class LocationTemplate{
        public String address; //"Alaska, USA",
        public GeocodeTemplate geocode; //Geocode Object
        public String accuracy; //"APPROXIMATE"

    }

    public JobTemplate job;
    public List<LocationTemplate> location = new List<LocationTemplate>();

}