Title: STATA code for cleaning data and performing statistical analyses in “Variations in visceral leishmaniasis burden, mortality and the pathway to care within Bihar, India”

Version: 0.1.0

Authors: Lloyd Chapman and Sarah Jervis

Email: Lloyd.Chapman@lshtm.ac.uk

Description: STATA code for cleaning data from CARE India’s 2013 situation assessment of visceral leishmanisis (VL) incidence in Bihar State, India, during Jan 2012-Jun 2013, and running statistical analyses of factors affecting onset-to-diagnosis and onset-to-treatment times and all-cause mortality among the identified VL patients (as described in [1]). The code for cleaning the data is in “clean_data.do” and that for running the statistical analyses (negative binomial regression of the waiting times and logistic regression of the mortality status) is in “regression12_13.do”.   


Archive contents:
clean_data.do
regression12_13.do

Developed in: STATA/SE 14.2 (Copyright 1985-2015 StataCorp LLC)

Installation: STATA, which requires a user license, must be installed to run the code. The  raw data and manually cleaned portions of data are also required. The raw data is available upon written request to Dr Nutan Jain (e-mail: nutan@iihmr.edu.in) of the Institutional Committee for Ethics and Review of Health Management Research Office, under the Indian Institute of Health Management Research (IIHMR). The manually cleaned data is available on written request to Dr Lloyd Chapman (Lloyd.Chapman@lshtm.ac.uk) at the London School of Hygiene and Tropical Medicine. STATA can be downloaded from https://www.stata.com/order/download-details/. Information on installing and activating STATA can be found at https://www.stata.com/install-guide/. To run the code, save the data and contents of this archive in a folder, open STATA and change the working directory to the folder in which the files are saved. The code can then be run by typing “do clean_data” at the command prompt, followed by “do regression12_13”.

License: GNU Affero General Public License v3.0 (http://www.gnu.org/licenses/agpl-3.0.txt)

References: [1] Jervis S, Chapman LAC, et al. Variations in visceral leishmaniasis burden, mortality and the pathway to care within Bihar, India. Parasites & Vectors 2017; 10(1):601.