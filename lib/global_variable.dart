library globals;


String? mainCourseId;
late String diurl;
late String payurl;
var downloadCertificateLink = "";
// const mockUpHeight = 896;
// const mockUpWidth = 414;
bool quizCleared = false;
List quiztrack=[];
String phone = "";
String email = "";
String name = "";
String? action;
String role = "";
String? signoutvalue;
var actualCode;
String phoneNumberexists = 'false';
String linked = 'false';
dynamic credental;
String googleAuth = 'false';
List moduleList = [];
List courseList = [
  "Select Course Name"
];
Map coursemoduelmap = {
  "Data Analyst Case Studies": [
    "US Pollution Analysis",
    "AirBnB Data Analysis",
    "Supply Chain Management",
    "HR Employee Data Analysis",
    "Call Centre Call Review Analysis"
  ],
  "R Language": [
    "Fundamental Of R",
    "Vectors",
    "Control Statements",
    "Functions,Factors & Lists in R",
    "Matrix & Dataframe",
    "Dplyr & Visualizations",
    "Case Study"
  ],
  "Demystify Deep Learning": [
    "Neural Network Module",
    "Computer Vision Module",
    "NLP Module",
    "Time Series Module"
  ],
  "Tableau for Data Analysis": [
    "Tableau Introduction",
    "Different Types of plots",
    "Data types and Filters in Tableau",
    "Applying Analytics to Tableau",
    "Dashboard",
    "Working with multiple data sources",
    "Level of Detail",
    "Case Studies"
  ],
  "Power Bi Course": [
    "Tutorial Section",
    "More on DAX in Detail",
    "Powerbi Case Studies"
  ],
  "Course Introduction": ["Instruction Videos"],
  "Julia for data science": ["Tutorial Videos"],
  "Kaggle Course": ["Tutorial Video"],
  "Big Data engineering Placement assurance program": [
    "SQL",
    "Introduction to Big Data & Hadoop",
    "MapReduce",
    "Sqoop",
    "Hive",
    "NoSQL DataBases",
    "Kafka",
    "Scala",
    "Spark(Optimization,streaming)",
    "Big Data on Cloud Airflow",
    "End to End Projects"
  ],
  "CloudyML Job Hunting Course": [
    "How To Build Resume & Linkedin ?",
    " HR/Managerial Questions",
    "Mock Interview"
  ],
  "Basic Excel": ["Tutorial Video"],
  "Basic ML Course": [
    "Feature Selection",
    "Feature Engineering",
    "Linear Regression",
    "Multiple Regression",
    "Logistic Regression",
    "Decision Tree",
    "Clustering"
  ],
  "Machine Learning": [
    "Feature Selection",
    "Feature Engineering",
    "Linear Regression",
    "Multiple Linear Regression",
    "Advance Linear Regression",
    "Logistic Regression",
    "PCA",
    "KNN",
    "Decision Tree",
    "Naive Bayes",
    "Bagging",
    "Boosting",
    "Clustering",
    "Support Vector Machine",
    "Hypothesis Testing",
    "Gradient Descent",
    "Model Deployment Module"
  ],
  "Microsoft Azure Certification AZ-900 Course": ["Tutorial Videos"],
  "Data science and analytics industry projects": [
    "Mcdonald's Food Nutrition Analysis  (FMCG)",
    "New York AirBnB Occupancy Analysis  (Hospitality)",
    "Customer Satisfaction Analysis (IT)",
    "Employee Attrition Analysis (IT)",
    "US Air Pollution Analysis  (Environmental)",
    "Supply Chain Management Analysis (FMCG)",
    "US Election 2020 Forecast Analysis (Election)",
    "Hourly Energy Consumption Analysis (Transmission)",
    "Uber Data Analysis ( Transportation )",
    "Customer Churn Analysis ( Retail )",
    "Covid-19 Analysis (Healthcare)",
    "Airline Flight Traffic Analysis (Airline )",
    "Life-Expectancy Analysis (Healthcare )",
    "Walmart Sales Analysis ( Retail )",
    "IPL Cricket Analysis ( Sports )",
    "Loan Application Analysis ( Banking)",
    "Superstore Sales Analysis (Retail )",
    "AI Robotics Employee Attrition Problem (IT)",
    "Seoul Bike Trip Duration Prediction (Transportation)",
    "Chronic Kidney Disease Classification(Health)",
    "Exhibit Art Sculpture Shipping Cost Prediction(Art)",
    "Merchandise Popularity Prediction(Merchandise)",
    "ODI Cricket Match Prediction(Sports)",
    "Steam Video Games Recommender System(Gaming)",
    "Financial News Headline Sentiment Analysis(Media)",
    "Ethereum Fraud Detection(Finance)",
    "Electrical Fault Detection(IOT)",
    "Quora Question Pair Similarity(Social Media)",
    "Newyork Taxi Demand Prediction(Transportation)",
    "Stack Exchange Keyword Extraction Problem By Facebook (Social Media)",
    "Facebook Friend Recommendation Using Graph Mining(Social Media)",
    "Microsoft Malware Detection Problem(IT)",
    "Personalised Cancer Diagnosis(Health)",
    "Autocorrect ",
    "English To French Translator",
    "Text Generation With RNN",
    "Email Classification Using BERT",
    "Flower Classification with CNN (Webapp using Gradio )",
    "Sentiment Analysis Recommender System",
    "Power Consumption Prediction",
    "Retail Sales Prediction",
    "Human Activity Recognition",
    "Crop Recommendation System",
    "Fertilizer Recommendation System"
  ],
  "Interview QnAs Package": ["Interview QNA PDFS"],
  "MS Excel Course": ["Tutorial Section"],
  "General Aptitude Course": ["Quantitative", "Logical", "Verbal"],
  "Maths & Statistics Course": [
    "Linear Algebra",
    "Calculus",
    "Statistics & Probability",
    "Linear Algebra Tasks"
  ],
  "Introduction To Data Science": ["Tutorial Videos"],
  "Apply for internship": ["Internship Link"],
  "Amazon Quicksight": ["Tutorial Video"],
  "Google Data Studio": ["Tutorial Video"],
  "Industry Project(Machine Learning)": [
    "Employee Attrition Problem",
    "Chronic Kidney Disease Classification",
    "Seoul Bike Trip Duration Prediction",
    "Quora Question Pair",
    "Newyork Taxi Demand Prediction",
    "Credit Risk Analysis",
    "Facebook Case Study",
    "Financial News Headline Sentiment Analysis",
    "Loan Default Case Study"
  ],
  "Python For Data science": [
    "Python Basics + Python Reloaded",
    "Python Intermediate",
    "Regex",
    "HackerRank",
    "Numpy",
    "Pandas",
    "Data Cleaning",
    "EDA"
  ],
  "SQL For Data Science": [
    "Basic SQL Module",
    "Intermediate SQL Module",
    "Advanced SQL Module",
    "Case studies"
  ],
  "test course": ["New Module", "CloudyML"],
  "DSA For Data Science": [
    "Classes",
    "Time Complexity",
    " Arrays",
    " Recursion",
    "Sorting Algorithm",
    "Linkedlist",
    "Stack & Queue",
    " Trees",
    " Dynamic Programming",
    " Graphs"
  ],
  "Deep Learning Project": ["Projects"]
};
String cuponcode = '';
String cuponcourse = '';
String cuponname = '';
String cupondiscount = '';
String cupontype = '';
String cuponcourseprice = '';

var moneyrefcode = '';
var chatcount;
String? survay;
