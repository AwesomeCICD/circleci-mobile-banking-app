import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

const App = () => {
  const handleSend = () => {
    // Kick off the send-money flow.
  };

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Welcome back, let's move some money</Text>
      <Text style={styles.title}>Welcome to Payments</Text>
      <TouchableOpacity style={styles.button} onPress={handleSend}>
        <Text style={styles.buttonText}>Send money</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  welcome: { fontSize: 14, color: '#666' },
  title: { fontSize: 24, fontWeight: 'bold' },
  button: { marginTop: 16, paddingVertical: 12, paddingHorizontal: 24, backgroundColor: '#0057ff', borderRadius: 8 },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});

export default App;
