import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

const App = () => {
  const handleSend = () => {
    console.log('Send money pressed');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Welcome back</Text>
      <Text style={styles.subtitle}>Ready to move your money?</Text>
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
  subtitle: { fontSize: 16, color: '#444', marginBottom: 8 },
  title: { fontSize: 24, fontWeight: 'bold' },
  button: { marginTop: 16, paddingVertical: 12, paddingHorizontal: 24, backgroundColor: '#0a7', borderRadius: 8 },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: 'bold' },
});

export default App;
