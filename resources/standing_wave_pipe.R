# Standing Wave in a Closed-Open Pipe
# Perfect for illustrating vocal tract resonance
# Closed end = glottis, Open end = lips

library(ggplot2)
library(dplyr)
library(tidyr)

# Function to create standing wave data for closed-open pipe
# Closed end at x=0, Open end at x=L
create_standing_wave <- function(L = 17.5,      # pipe length in cm (typical vocal tract)
                                  harmonic = 1,   # which harmonic (1, 3, 5, 7...)
                                  time = 0,       # time point for animation
                                  n_points = 200) {
  
  # For closed-open pipe, only odd harmonics exist
  # Wavelength: λ = 4L/(2n-1) where n = 1,2,3...
  # Wave number: k = π(2n-1)/(2L)
  
  n <- harmonic  # harmonic number (1=fundamental, 3=third, 5=fifth)
  k <- pi * (2*n - 1) / (2*L)  # wave number
  omega <- 2 * pi * 1  # angular frequency (arbitrary units)
  
  # Position along pipe
  x <- seq(0, L, length.out = n_points)
  
  # PRESSURE wave: max at closed end (x=0), min at open end (x=L)
  # P(x,t) = A * cos(kx) * cos(ωt)
  pressure <- cos(k * x) * cos(omega * time)
  
  # PARTICLE VELOCITY wave: min at closed end, max at open end
  # v(x,t) = A * sin(kx) * cos(ωt)
  particle_velocity <- sin(k * x) * cos(omega * time)
  
  data.frame(
    position = x,
    pressure = pressure,
    velocity = particle_velocity,
    harmonic = n,
    time = time
  )
}

# Function to plot standing wave
plot_standing_wave <- function(data, 
                               L = 17.5,
                               title = "Standing Wave in Closed-Open Pipe",
                               show_mirrored = FALSE) {
  
  # Reshape data for plotting both waves
  data_long <- data %>%
    pivot_longer(cols = c(pressure, velocity),
                 names_to = "wave_type",
                 values_to = "amplitude")
  
  # If mirrored, create both positive and negative phases
  if (show_mirrored) {
    data_mirrored <- bind_rows(
      data_long %>% mutate(phase = "positive"),
      data_long %>% mutate(amplitude = -amplitude, phase = "negative")
    )
    data_plot <- data_mirrored
    alpha_val <- 0.7  # slight transparency for overlapping waves
  } else {
    data_plot <- data_long %>% mutate(phase = "positive")
    alpha_val <- 1
  }
  
  # Create plot
  p <- ggplot(data_plot, aes(x = position, y = amplitude, 
                             color = wave_type, linetype = phase)) +
    geom_line(size = 1.2, alpha = alpha_val) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    
    # Mark closed end (glottis)
    geom_vline(xintercept = 0, linetype = "solid", color = "black", size = 1) +
    annotate("text", x = 0, y = 1.3, label = "Closed\n(Glottis)", 
             hjust = 0.5, size = 3.5) +
    
    # Mark open end (lips)
    annotate("segment", x = L, xend = L, y = -1.2, yend = 1.2,
             linetype = "dotted", color = "black", size = 0.8) +
    annotate("text", x = L, y = 1.3, label = "Open\n(Lips)", 
             hjust = 0.5, size = 3.5) +
    
    # Styling
    scale_color_manual(
      values = c("pressure" = "#E41A1C", "velocity" = "#377EB8"),
      labels = c("Pressure", "Particle Velocity"),
      name = "Wave Type"
    ) +
    scale_linetype_manual(
      values = c("positive" = "solid", "negative" = "solid"),
      guide = if(show_mirrored) "none" else "none"
    ) +
    labs(
      title = title,
      subtitle = sprintf("Harmonic %d | Length = %.1f cm%s", 
                        unique(data$harmonic), L,
                        if(show_mirrored) " | Showing both phases" else ""),
      x = "Position along pipe (cm)",
      y = "Normalized Amplitude"
    ) +
    theme_minimal(base_size = 12) +
    theme(
      legend.position = "bottom",
      plot.title = element_text(face = "bold", size = 14),
      panel.grid.minor = element_blank()
    ) +
    coord_cartesian(ylim = c(-1.4, 1.4))
  
  return(p)
}

# ============================================
# EXAMPLE 1: Fundamental frequency (n=1)
# ============================================
cat("Example 1: Fundamental (1st harmonic)\n")
cat("This is F1 for a neutral vocal tract\n\n")

data_f1 <- create_standing_wave(L = 17.5, harmonic = 1, time = 0)
p1 <- plot_standing_wave(data_f1, L = 17.5, 
                         title = "Fundamental Frequency (F1)")
print(p1)

# Calculate frequency
c_sound <- 35000  # speed of sound in cm/s
L <- 17.5
f1 <- c_sound / (4 * L)
cat(sprintf("F1 ≈ %.0f Hz (for 17.5 cm vocal tract)\n\n", f1))

# Same plot with mirrored waves (both phases)
cat("Example 1b: Fundamental with mirrored waves\n")
p1_mirror <- plot_standing_wave(data_f1, L = 17.5, 
                                title = "Fundamental Frequency (F1) - Both Phases",
                                show_mirrored = TRUE)
print(p1_mirror)


# ============================================
# EXAMPLE 2: Third harmonic (n=3)
# ============================================
cat("\nExample 2: Third harmonic\n")
data_f3 <- create_standing_wave(L = 17.5, harmonic = 3, time = 0)
p2 <- plot_standing_wave(data_f3, L = 17.5,
                         title = "Third Harmonic (F3)",
                         show_mirrored = TRUE)
print(p2)

f3 <- 3 * c_sound / (4 * L)
cat(sprintf("F3 ≈ %.0f Hz\n\n", f3))


# ============================================
# EXAMPLE 3: Fifth harmonic (n=5)
# ============================================
cat("Example 3: Fifth harmonic\n")
data_f5 <- create_standing_wave(L = 17.5, harmonic = 5, time = 0)
p3 <- plot_standing_wave(data_f5, L = 17.5,
                         title = "Fifth Harmonic (F5)")
print(p3)

f5 <- 5 * c_sound / (4 * L)
cat(sprintf("F5 ≈ %.0f Hz\n\n", f5))


# ============================================
# EXAMPLE 4: Comparison of multiple harmonics
# ============================================
cat("Example 4: All three harmonics together\n")

# Create data for first three odd harmonics
data_multi <- bind_rows(
  create_standing_wave(L = 17.5, harmonic = 1, time = 0),
  create_standing_wave(L = 17.5, harmonic = 3, time = 0),
  create_standing_wave(L = 17.5, harmonic = 5, time = 0)
)

p4 <- ggplot(data_multi, aes(x = position, y = pressure, color = factor(harmonic))) +
  geom_line(size = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "solid", color = "black", size = 1) +
  annotate("text", x = 0, y = 1.2, label = "Closed", hjust = 0.5, size = 3) +
  annotate("segment", x = 17.5, xend = 17.5, y = -1.1, yend = 1.1,
           linetype = "dotted", color = "black") +
  annotate("text", x = 17.5, y = 1.2, label = "Open", hjust = 0.5, size = 3) +
  scale_color_brewer(palette = "Set1", name = "Harmonic",
                     labels = c("1 (F1)", "3 (F3)", "5 (F5)")) +
  labs(
    title = "Pressure Waves: Multiple Harmonics",
    subtitle = "Closed-Open Pipe (Vocal Tract Model)",
    x = "Position along pipe (cm)",
    y = "Normalized Pressure"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"))

print(p4)


# ============================================
# EXAMPLE 5: Animation frames (optional)
# ============================================
cat("\nExample 5: Create animation frames\n")
cat("Uncomment and run if you want to create an animation\n\n")

# # Uncomment to create animation frames
# library(gganimate)
# 
# # Create data for multiple time points
# time_points <- seq(0, 2*pi, length.out = 30)
# data_anim <- bind_rows(lapply(time_points, function(t) {
#   create_standing_wave(L = 17.5, harmonic = 1, time = t)
# }))
# 
# p_anim <- plot_standing_wave(data_anim, L = 17.5) +
#   transition_time(time) +
#   labs(subtitle = "Harmonic 1 | Time: {frame_time}")
# 
# animate(p_anim, nframes = 30, fps = 10)


# ============================================
# HELPER: Calculate formant frequencies
# ============================================
calculate_formants <- function(L = 17.5, c = 35000, n_formants = 5) {
  # For closed-open pipe: f_n = (2n-1) * c / (4L)
  # where n = 1, 2, 3, ...
  
  n <- 1:n_formants
  formants <- (2*n - 1) * c / (4*L)
  
  data.frame(
    formant = paste0("F", n),
    harmonic = 2*n - 1,
    frequency_Hz = round(formants, 0)
  )
}

cat("\nFormant frequencies for neutral 17.5 cm vocal tract:\n")
print(calculate_formants())

cat("\n==============================================\n")
cat("KEY OBSERVATIONS:\n")
cat("==============================================\n")
cat("1. Pressure is MAX at closed end (glottis)\n")
cat("2. Pressure is MIN at open end (lips)\n")
cat("3. Particle velocity is opposite: MIN at closed, MAX at open\n")
cat("4. Only ODD harmonics exist (1, 3, 5, 7...)\n")
cat("5. These correspond to formants F1, F3, F5, F7...\n")
cat("6. For 17.5 cm tract: F1≈500Hz, F3≈1500Hz, F5≈2500Hz\n")
cat("==============================================\n")
