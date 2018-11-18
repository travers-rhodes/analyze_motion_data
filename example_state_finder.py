# complete example for alexandre
import matplotlib.pyplot as plt
# you may need to source /opt/ros/kinetic/setup.bash in order to import rosbag
import rosbag

# copy bag file to a txt for easy manipulation.
# Columns are time (of spoon message), spoon position and orientation, and most recent cap recording and orientation.
# a more advanced setup could interpolate cap pose to match spoon recording time.

bag = rosbag.Bag('data/2018-10-31-13-03-50_just_poses.bag')
counter = 0
last_spoon_msg = None;
last_hat_msg = None;
with open("pose_data_full_sample.txt", "w+") as f:
    for topic, msg, t in bag.read_messages(topics=['/vrpn_client_node/spoon/pose','/vrpn_client_node/manuelcap/pose']):
        if "spoon" in topic:
            last_spoon_msg = msg
        if "manuel" in topic:
            last_hat_msg = msg
      
        if last_spoon_msg and last_hat_msg and "spoon" in topic:
            f.write("%s,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n" % (t,
                last_spoon_msg.pose.position.x, last_spoon_msg.pose.position.y, last_spoon_msg.pose.position.z,
                last_spoon_msg.pose.orientation.w, last_spoon_msg.pose.orientation.x, 
                last_spoon_msg.pose.orientation.y, last_spoon_msg.pose.orientation.z,
                last_hat_msg.pose.position.x, last_hat_msg.pose.position.y, last_hat_msg.pose.position.z,
                last_hat_msg.pose.orientation.w, last_hat_msg.pose.orientation.x, 
                last_hat_msg.pose.orientation.y, last_hat_msg.pose.orientation.z))
        counter += 1
        # if you want a larger sample of data, increase this value
        if counter > 100000:
            break
    bag.close()

    
# set up hidden markov model parameters
from hmmlearn import hmm

# helper function to plot simple gaussian-emmision HMM model with n_components states
def plot_with_n_components(n_components, z_data):
    model = hmm.GaussianHMM(n_components=n_components, covariance_type="full", n_iter=100, params ="smtc")
    model.fit(z_data)
    est_z = model.predict(z_data)
    plt.plot(z_data)
    plt.plot(model.means_[est_z])

    
# now, read in the newly created txt file and model it and plot the resulting model
import numpy as np
from statsmodels.nonparametric.smoothers_lowess import lowess
all_data = np.loadtxt('pose_data_full_sample.txt', delimiter=',')
# see https://hmmlearn.readthedocs.io/en/latest/tutorial.html

# smooth the data
raw_z_data = all_data[:,3:4]
z_data = lowess(np.squeeze(raw_z_data), range(np.size(raw_z_data,0)), is_sorted=True, frac=0.025, it=0)[:,1:2]
# First division is the nice "waiting/feeding"
plot_with_n_components(2,z_data)

plt.show()
