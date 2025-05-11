Here’s an updated and detailed `README.md` documentation based on your description of both **Donor** and **Receiver** sections. This will help explain the flow of the application, how the donor and receiver sections work, and how to use them. You can present this for an interview to explain the functionality.

---

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



## 📽️ App Demo

*Add screenshots here showing the following pages:*

* **Donor Registration Form**

  * Displaying the form where hospitals add donor details.

* **Receiver Donor Search**

  * Showing the page where receivers search for nearby plasma donors.

* **Blood Group Distribution Chart**

  * Visualization of plasma donor statistics.

---

