# ============================================================
# Case Study 2 — Publication-Quality Charts (ggplot2)
# Ad Irritation & User Frustration Study
# ============================================================

library(ggplot2)

# --- Dark theme matching portfolio aesthetic ---
theme_portfolio <- function() {
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "#0f0f17", color = NA),
    panel.background = element_rect(fill = "#0f0f17", color = NA),
    panel.grid.major.y = element_line(color = "#1a1a2e", linewidth = 0.3),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(color = "#a0a0b8"),
    plot.title = element_text(color = "#f0f0f5", face = "bold", size = 18, margin = margin(b = 8)),
    plot.subtitle = element_text(color = "#6b6b80", size = 11, margin = margin(b = 20)),
    axis.text = element_text(color = "#a0a0b8", size = 11),
    axis.title = element_text(color = "#6b6b80", size = 11),
    axis.ticks = element_blank(),
    legend.background = element_rect(fill = "#0f0f17", color = NA),
    legend.text = element_text(color = "#a0a0b8"),
    legend.title = element_text(color = "#f0f0f5", face = "bold"),
    legend.key = element_rect(fill = "#0f0f17", color = NA),
    plot.margin = margin(30, 30, 30, 30)
  )
}

# ============================================================
# Chart 1: Mean Annoyance Rating by Ad Attribute
# ============================================================

annoyance_data <- data.frame(
  Attribute = factor(
    c("Ad Length", "Poor Quality", "Irrelevance", "High Frequency"),
    levels = c("High Frequency", "Irrelevance", "Poor Quality", "Ad Length")
  ),
  Mean = c(9.02, 8.76, 7.81, 7.2),
  SD = c(0.8, 1.1, 1.3, 1.5)
)

p1 <- ggplot(annoyance_data, aes(x = Attribute, y = Mean, fill = Mean)) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_errorbar(aes(ymin = Mean - SD * 0.5, ymax = pmin(Mean + SD * 0.5, 10)),
                width = 0.2, color = "#a0a0b8", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.2f", Mean)),
            hjust = -0.2, color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient(low = "#4285f4", high = "#e74c3c") +
  scale_y_continuous(limits = c(0, 10.5), breaks = seq(0, 10, 2),
                     expand = expansion(mult = c(0, 0.05))) +
  coord_flip() +
  labs(
    title = "Mean Annoyance Rating by Ad Attribute",
    subtitle = "1\u201310 Likert Scale  |  n = 59 respondents  |  Error bars = \u00b10.5 SD",
    x = NULL,
    y = "Mean Annoyance Score"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_annoyance_bars.png", p1,
       width = 10, height = 5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 1 saved: assets/chart_annoyance_bars.png\n")

# ============================================================
# Chart 2: Ad Placement Irritation (Donut Chart)
# ============================================================

placement_data <- data.frame(
  Placement = factor(
    c("Mid-roll", "Pre-roll", "Post-roll", "Overlay"),
    levels = c("Mid-roll", "Pre-roll", "Post-roll", "Overlay")
  ),
  Percentage = c(44.4, 30.2, 12.8, 12.6)
)

p2 <- ggplot(placement_data, aes(x = 2, y = Percentage, fill = Placement)) +
  geom_col(width = 1, color = "#0f0f17", linewidth = 1.2) +
  coord_polar(theta = "y") +
  xlim(0.5, 2.5) +
  scale_fill_manual(values = c(
    "Mid-roll" = "#e74c3c",
    "Pre-roll" = "#f39c12",
    "Post-roll" = "#4285f4",
    "Overlay" = "#34a853"
  )) +
  geom_text(aes(label = paste0(Percentage, "%")),
            position = position_stack(vjust = 0.5),
            color = "#fff", fontface = "bold", size = 4.5) +
  labs(
    title = "Most Irritating Ad Placement",
    subtitle = "% of respondents rating each format as most annoying  |  n = 59",
    fill = "Ad Placement"
  ) +
  theme_portfolio() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    legend.position = "right"
  )

ggsave("assets/chart_placement_donut.png", p2,
       width = 9, height = 6, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 2 saved: assets/chart_placement_donut.png\n")

# ============================================================
# Chart 3: Key Metrics (Lollipop Chart)
# ============================================================

metrics_data <- data.frame(
  Metric = factor(
    c("Gave max score\nfor long ads",
      "YouTube as\nprimary platform",
      "Mid-roll rated\nmost irritating"),
    levels = c("Mid-roll rated\nmost irritating",
               "Gave max score\nfor long ads",
               "YouTube as\nprimary platform")
  ),
  Value = c(66.7, 88.1, 44.4)
)

p3 <- ggplot(metrics_data, aes(x = Metric, y = Value)) +
  geom_segment(aes(xend = Metric, y = 0, yend = Value),
               color = "#4285f4", linewidth = 2) +
  geom_point(size = 10, color = "#4285f4") +
  geom_point(size = 7, color = "#34a853") +
  geom_text(aes(label = paste0(Value, "%")),
            color = "#fff", fontface = "bold", size = 3.5) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25),
                     labels = function(x) paste0(x, "%")) +
  coord_flip() +
  labs(
    title = "Key Study Metrics",
    subtitle = "Critical findings at a glance  |  n = 59 respondents",
    x = NULL,
    y = NULL
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_key_metrics.png", p3,
       width = 9, height = 4.5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 3 saved: assets/chart_key_metrics.png\n")

# ============================================================
# Chart 4: Coping Mechanisms
# ============================================================

coping_data <- data.frame(
  Mechanism = factor(
    c("Skip immediately", "Use ad-blocker", "Pay for premium", "Mute & ignore"),
    levels = c("Mute & ignore", "Pay for premium", "Use ad-blocker", "Skip immediately")
  ),
  Percentage = c(78, 52, 35, 22)
)

p4 <- ggplot(coping_data, aes(x = Mechanism, y = Percentage, fill = Percentage)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = paste0(Percentage, "%")),
            hjust = -0.15, color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient(low = "#34a853", high = "#e74c3c") +
  scale_y_continuous(limits = c(0, 100), expand = expansion(mult = c(0, 0.1))) +
  coord_flip() +
  labs(
    title = "User Coping Mechanisms",
    subtitle = "How users respond to ad irritation  |  n = 59 respondents",
    x = NULL,
    y = "% of Respondents"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/chart_coping.png", p4,
       width = 10, height = 4.5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 4 saved: assets/chart_coping.png\n")
cat("\n\u2713 All 4 charts generated successfully!\n")

# ============================================================
# Case Study 1 — Publication-Quality Charts (ggplot2)
# Improving Learnability & Mitigating Cybersickness in Tactical VR
# ============================================================

# ============================================================
# Chart 5: VRSQ Oculomotor Strain — Highlight Participants
# ============================================================

vr_strain <- data.frame(
  Condition = factor(
    c("P8 (Initial)", "P3 (Advanced)", "P3 (Initial)"),
    levels = c("P3 (Initial)", "P3 (Advanced)", "P8 (Initial)")
  ),
  Percent = c(83.33, 41.66, 20.83)
)

p5 <- ggplot(vr_strain, aes(x = Condition, y = Percent, fill = Percent)) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(aes(label = paste0(sprintf("%.1f", Percent), "%")),
            hjust = -0.12, color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient(low = "#4285f4", high = "#e74c3c") +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20),
                     labels = function(x) paste0(x, "%"),
                     expand = expansion(mult = c(0, 0.08))) +
  coord_flip() +
  labs(
    title = "VRSQ Oculomotor Strain — Highlight Participants",
    subtitle = "Notable strain points observed during the study  |  n = 8 VR novices",
    x = NULL,
    y = "% Oculomotor Strain"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/vr_chart_oculomotor_strain.png", p5,
       width = 10, height = 5, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 5 saved: assets/vr_chart_oculomotor_strain.png\n")

# ============================================================
# Chart 6: Key Study Metrics (VR)
# ============================================================

vr_metrics <- data.frame(
  Metric = factor(
    c("Peak oculomotor\nstrain observed",
      "Reported UI clutter\n& mis-grabs",
      "Task abandonment\nobserved"),
    levels = c("Task abandonment\nobserved",
               "Reported UI clutter\n& mis-grabs",
               "Peak oculomotor\nstrain observed")
  ),
  Value = c(83.33, 37.5, 12.5)
)

p6 <- ggplot(vr_metrics, aes(x = Metric, y = Value)) +
  geom_segment(aes(xend = Metric, y = 0, yend = Value),
               color = "#4285f4", linewidth = 2) +
  geom_point(size = 10, color = "#4285f4") +
  geom_point(size = 7, color = "#34a853") +
  geom_text(aes(label = paste0(sprintf("%.1f", Value), "%")),
            color = "#fff", fontface = "bold", size = 3.5) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 25),
                     labels = function(x) paste0(x, "%")) +
  coord_flip() +
  labs(
    title = "Key Study Metrics (VR)",
    subtitle = "High-signal outcomes at a glance  |  n = 8 VR novices",
    x = NULL,
    y = NULL
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/vr_chart_key_metrics.png", p6,
       width = 10, height = 4.8, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 6 saved: assets/vr_chart_key_metrics.png\n")

# ============================================================
# Chart 7: GEQ Immersion Deltas (Before → After)
# ============================================================

vr_deltas <- data.frame(
  Group = factor(
    c("Participant 7", "Study average"),
    levels = c("Study average", "Participant 7")
  ),
  Delta = c(-0.83, -0.50)
)

p7 <- ggplot(vr_deltas, aes(x = Group, y = Delta, fill = Delta)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_hline(yintercept = 0, color = "#1a1a2e", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%+.2f", Delta)),
            hjust = ifelse(vr_deltas$Delta < 0, 1.08, -0.08),
            color = "#f0f0f5", fontface = "bold", size = 5) +
  scale_fill_gradient2(low = "#e74c3c", mid = "#4285f4", high = "#34a853", midpoint = 0) +
  scale_y_continuous(
    limits = c(min(vr_deltas$Delta) - 0.12, 0.05),
    breaks = seq(-1, 0, 0.2),
    expand = expansion(mult = c(0.02, 0.02))
  ) +
  coord_flip() +
  labs(
    title = "GEQ Immersion Deltas (Before → After)",
    subtitle = "Negative values indicate reduced immersion after repeated actions",
    x = NULL,
    y = "Immersion Delta"
  ) +
  theme_portfolio() +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#1a1a2e", linewidth = 0.3)
  )

ggsave("assets/vr_chart_immersion_deltas.png", p7,
       width = 10, height = 4.6, dpi = 300, bg = "#0f0f17")

cat("\u2713 Chart 7 saved: assets/vr_chart_immersion_deltas.png\n")

cat("\n\u2713 VR charts appended successfully!\n")
