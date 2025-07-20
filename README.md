# 🩸 PlasmaX – Plasma Donation Management System

PlasmaX is a mobile application designed to streamline the management of plasma donations. The app facilitates two main sections:

1. **Donor Section** - Managed by hospitals, where plasma donors can register and their details are stored for future reference.
2. **Receiver Section** - Allows plasma receivers to search for available donors based on location, whether from a hospital or an individual.

---

## 🚀 Features

### **Donor Section** (Hospital Management)

* **Plasma Donation Registration:**

  * Hospitals can register donors, entering their details such as name, blood group, donation date, and other medical details.
  * Donors are stored in the system with expiry information, as plasma has a shelf life of 90 days from the donation date.
* **Plasma Expiry Calculation:**

  * Automatically tracks and calculates the expiry date of the plasma, ensuring only valid donations are considered.

### **Receiver Section** (Plasma Requester)

* **Search for Donors:**

  * Plasma receivers can search for available donors based on their **location**.
  * The receiver can select if they want plasma from a **hospital** or **individual donor**.
* **Hospital Plasma Availability:**

  * If the receiver opts for a hospital donation, they are shown a list of plasma available in nearby hospitals.
* **Individual Donor Plasma Availability:**

  * If the receiver chooses an individual donor, the app will display a list of individuals who have donated plasma within the last 90 days and are available in the nearby area.
  * Individual donors are only shown if they have donated their plasma in a hospital.

---

## 🛠️ Tech Stack

| Tech               | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| Flutter            | UI development platform                                      |
| Firebase Firestore | Cloud database for storing donor and receiver data           |
| SharedPreferences  | Local storage for saving session data (e.g., hospital login) |
| fl\_chart          | Library for visualizing donor blood group distribution       |

---


## 🔑 Key Features for **Donor** Section

1. **Hospital Login:**

   * Hospitals log in to the app and can manage donor records.

2. **Adding Donors:**

   * A form is available for hospitals to enter the donor's personal details, blood group, donation date, and medical information.

3. **Plasma Expiry:**

   * Plasma donation expiry is calculated based on the date of donation. Only valid donations (within the last 90 days) are considered for further use.

4. **Plasma Status Tracking:**

   * Donors' plasma availability status is tracked, allowing hospitals to manage their plasma stock.

---

## 🔑 Key Features for **Receiver** Section

1. **Search for Donors:**

   * Plasma receivers can search for nearby plasma donors by location.

2. **Choose Plasma Source (Hospital or Individual):**

   * **Hospital Plasma:** Receivers can search for plasma available in nearby hospitals, categorized by location.
   * **Individual Donors:** When selecting individual donors, the app shows people who have donated plasma at a hospital and whose plasma is still valid (donated within the last 90 days).

3. **Receiver Location Input:**

   * Receivers enter their location to find donors that are closest to them, ensuring that the search results are relevant and timely.

---

## App Demo

  <h2>Project</h2>
  <h3>Home page</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/home_screen.jpg"/>
  <h3>Signup Page</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/signup.jpg"/>
  <h3>Login Page</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/login.jpg"/>
  <h3>Dashboard</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/dashboard.jpg"/>
  <h3>Donor Or Receiver</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/donor_receiver.jpg"/>
  <h3>Donor by persons List</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/donors_list.jpg" />
 <h3>Hospital profile</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/profile_page.jpg" />
  <h3>Donor by hospital and Centers</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/hospital_donors.jpg" />
 <h3>Receiver near by centers locatioin</h3>
  <img src="https://raw.githubusercontent.com/lokeshkumar-2003/PlasmaX-HealthApp/refs/heads/main/demo/near_by_hospitals.jpg" />





